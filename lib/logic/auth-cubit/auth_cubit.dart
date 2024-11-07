import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../data/models/auth-model.dart';
part 'auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? get currentUser => _auth.currentUser;
  final ImagePicker _picker = ImagePicker();


  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoading());
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
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
        gender: ""
      );

      // Store user data in Firestore
      await _firestore.collection('users').doc(userModel.uid).set(userModel.toMap());

      emit(AuthSuccess(userCredential.user!));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    emit(AuthInitial());
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

      // Fetch updated user data and emit success state
      await fetchUserInfo();
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

      // Emit success state with updated user profile info
      await fetchUserInfo();
      emit(AuthProfilePhotoUpdateSuccess(currentUser!, UserModel(uid: uid, profilePhoto: photoUrl)));
    } catch (e) {
      emit(AuthProfilePhotoUpdateFailure(e.toString()));
    }
  }




  Future<void> fetchUserInfo() async {
    try {
      emit(AuthLoading());

      final uid = _auth.currentUser?.uid;

      if (uid != null) {
        // Fetch user data from Firestore
        final userDoc = await _firestore.collection('users').doc(uid).get();

        if (userDoc.exists) {
          UserModel userModel = UserModel.fromMap(userDoc.data()!);

          // Emit success state with user and userModel
          emit(AuthSuccess(_auth.currentUser!, userModel: userModel));
        } else {
          emit(AuthFailure("User data not found"));
        }
      } else {
        emit(AuthFailure("No current user"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}








