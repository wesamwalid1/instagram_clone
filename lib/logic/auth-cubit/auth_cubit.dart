import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/data/cache/cache.dart';
import '../../../../../data/models/auth-model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? get currentUser => _auth.currentUser;
  final ImagePicker _picker = ImagePicker();
  var cache = CacheHelper();

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      String token = doc.get('uid') as String;
      await cache.setData(key: 'auth_token', value: token);
      emit(AuthSuccess(_auth.currentUser!));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> register(String username, String email, String password) async {
    try {
      emit(AuthLoading());
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create a UserModel instance
      UserModel userModel = UserModel(
          uid: userCredential.user!.uid,
          profilePhoto: '',
          name: "",
          username: username,
          website: "",
          bio: "",
          email: email,
          phone: "",
          gender: "");

      // Store user data in Firestore
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toMap());

      emit(AuthSuccess(userCredential.user!));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signOut() async {
    await cache.deleteData(key: 'auth_token');
    emit(SignOut());
  }

  Future<void> updateProfile({
    required String name,
    required String username,
    required String bio,
    required String phone,
    required String gender,
    required String website,
  }) async {
    try {
      emit(AuthLoading());
      final uid = currentUser?.uid;

      if (uid == null) {
        emit(AuthFailure("No current user"));
        return;
      }

      // Update other user data in Firestore
      await _firestore.collection('users').doc(uid).update({
        'name': name,
        'username': username,
        'bio': bio,
        'phone': phone,
        'gender': gender,
        'website': website,
      });
      // Fetch and update all posts by this user in the 'posts' collection
      final userPostsQuery = await _firestore.collection('posts')
          .where('uid', isEqualTo: uid)
          .get();

      for (var doc in userPostsQuery.docs) {
        await doc.reference.update({
          'username': username,
        });
      }


      // Fetch updated user data and emit success state
      await fetchUserInfo(uid);
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> updateProfilePhoto() async {
    try {
      emit(AuthProfilePhotoUpdateLoading());

      // Pick an image from the gallery
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        emit(AuthProfilePhotoUpdateFailure("No image selected"));
        return;
      }

      // Get user ID and define the storage path
      final uid = currentUser?.uid;
      if (uid == null) {
        emit(AuthProfilePhotoUpdateFailure("No current user"));
        return;
      }

      // Upload the picked file to Firebase Storage
      final storageRef = _storage.ref().child('profilePhotos/$uid');
      await storageRef.putFile(File(pickedFile.path));
      final photoUrl = await storageRef.getDownloadURL();

      // Update Firestore with the new profile photo URL
      await _firestore.collection('users').doc(uid).update({
        'profilePhoto': photoUrl,
      });
      // Fetch and update all posts by this user in the 'posts' collection
      final userPostsQuery = await _firestore.collection('posts')
          .where('uid', isEqualTo: uid)
          .get();

      for (var doc in userPostsQuery.docs) {
        await doc.reference.update({
          'userImage': photoUrl,
        });
      }

      // Emit success state with updated user profile info
      await fetchUserInfo(uid);
      emit(AuthProfilePhotoUpdateSuccess(
          currentUser!, UserModel(uid: uid, profilePhoto: photoUrl)));
    } catch (e) {
      emit(AuthProfilePhotoUpdateFailure(e.toString()));
    }
  }

  Future<void> fetchUserInfo(String uid) async {
    try {
      emit(AuthLoading());


      // Fetch user data from Firestore
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        UserModel userModel = UserModel.fromMap(userDoc.data()!);

        // Emit success state with user and userModel
        emit(AuthSuccess(_auth.currentUser!, userModel: userModel));
      } else {
        emit(AuthFailure("User data not found"));
      }
        } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> searchUsers(String query, String currentUserUid) async {
    try {
      emit(AuthLoading()); // Emit loading state

      if (query.isEmpty) {
        emit(AuthSearchResults(
            [])); // If the query is empty, return empty results
        return;
      }

      // Query users collection to search by username
      final querySnapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThan: query + 'z')
          .get();

      // Map query results into a list of UserModel and exclude the current user
      final searchResults = querySnapshot.docs
          .where((doc) => doc.data()['uid'] != currentUserUid) // Exclude current user's account
          .map((doc) {
        return UserModel.fromMap(doc.data());
      }).toList();

      emit(AuthSearchResults(searchResults)); // Emit results
    } catch (e) {
      emit(AuthFailure(e.toString())); // Emit failure state in case of error
    }
  }

  // In AuthCubit:
  Future<void> followUser(UserModel targetUser) async {
    try {
      emit(AuthLoading());
      final currentUserUid = currentUser?.uid;

      if (currentUserUid == null) {
        emit(AuthFailure("No current user"));
        return;
      }

      // Fetch current user data
      DocumentSnapshot currentUserDoc = await _firestore.collection('users').doc(currentUserUid).get();
      UserModel currentUserModel = UserModel.fromMap(
          currentUserDoc.data() as Map<String, dynamic>
      );

      // Check if already following, toggle action
      bool isFollowing = currentUserModel.following?.contains(targetUser.uid) ?? false;

      if (isFollowing) {
        // Unfollow logic
        await _firestore.collection('users').doc(currentUserUid).update({
          'following': FieldValue.arrayRemove([targetUser.uid]),
          'followingCount': FieldValue.increment(-1),
        });

        await _firestore.collection('users').doc(targetUser.uid).update({
          'followers': FieldValue.arrayRemove([currentUserUid]),
          'followersCount': FieldValue.increment(-1),
        });

      } else {
        // Follow logic
        await _firestore.collection('users').doc(currentUserUid).update({
          'following': FieldValue.arrayUnion([targetUser.uid]),
          'followingCount': FieldValue.increment(1),
        });

        await _firestore.collection('users').doc(targetUser.uid).update({
          'followers': FieldValue.arrayUnion([currentUserUid]),
          'followersCount': FieldValue.increment(1),
        });
      }

      // Fetch updated user info after follow/unfollow
      await fetchUserInfo(currentUserUid);

      // Emit success state
      emit(AuthSuccess(_auth.currentUser!, userModel: currentUserModel));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }



  Future<void> fetchAllUsers() async {
    emit(FetchUsersLoading()); // Emit loading state

    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Query all users except the current user
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('uid', isNotEqualTo: currentUserId) // Exclude current user
          .get();

      List<UserModel> users = querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      emit(FetchUsersSuccess(users)); // Emit success state with users list
    } catch (e) {
      emit(FetchUsersError(
          'Failed to fetch users: ${e.toString()}')); // Emit error state
    }
  }



}
