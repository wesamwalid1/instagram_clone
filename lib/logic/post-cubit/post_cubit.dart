import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import '../../data/models/auth-model.dart';
import '../../data/models/post-model.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadPost({
    required String uid,
    required List<File> mediaFiles,
    required String description,
    required String location,
    required String username,
    required String userImage,
    required String mediaType, // 'image', 'video', 'carousel'
  }) async {
    emit(PostUploading());
    try {
      // Upload each file and store the URLs
      List<String> mediaUrls = [];
      for (File file in mediaFiles) {
        String url = await _uploadMediaToStorage(uid, file);
        mediaUrls.add(url);
      }

      // Create PostModel
      String postId = FirebaseFirestore.instance.collection('posts').doc().id;
      PostModel post = PostModel(
        postId: postId,
        uid: uid,
        mediaUrls: mediaUrls,
        description: description,
        location: location,
        username: username,
        userImage: userImage,
        mediaType: mediaType,
        createdAt: DateTime.now(),
        likes: [],
      );

      // Save to Firestore
      await FirebaseFirestore.instance.collection('posts').doc(postId).set({
        ...post.toMap(),
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('userPosts')
          .doc(postId)
          .set({...post.toMap()});



      emit(PostUploadSuccess(mediaUrls.join(", ")));
    } catch (e) {
      emit(PostUploadFailure(e.toString()));
    }
  }

  Future<String> _uploadMediaToStorage(String uid, File mediaFile) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('posts/$uid/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = storageRef.putFile(mediaFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload media: $e");
    }
  }

  /// Method to load all posts except for the current user's posts
  Future<void> loadPosts(String currentUserId) async {
    emit(PostLoading());
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isNotEqualTo: currentUserId)
          .get();

      // Extract posts as a list of maps
      List<PostModel> posts = snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      emit(PostLoadSuccess(posts));
    } catch (e) {
      emit(PostLoadFailure(e.toString()));
    }
  }

  /// Method to load posts from the current user's subcollection
  Future<void> loadUserPosts(String uid) async {
    emit(PostLoading());
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      List<PostModel> posts = snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      emit(PostLoadSuccess(posts));
    } catch (e) {
      emit(PostLoadFailure(e.toString()));
    }
  }

  Future<void> loadFollowedUserPosts(String currentUserId) async {
    emit(PostLoading());
    try {
      // Fetch the users the current user is following
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .get();
      // Check if the document exists
      if (!userDoc.exists) {
        emit(PostLoadFailure("User data not found."));
        return;
      }

      // Get the data and convert it to a UserModel
      final userModel = UserModel.fromMap(userDoc.data()!);
      print('Following list: ${userModel.following}'); // Debugging line

      if (userModel.following == null || userModel.following!.isEmpty) {
        emit(PostLoadFailure("You are not following anyone."));
        return;
      }
      List<String> followedUserIds = userModel.following!;

      // Ensure that the list has less than or equal to 10 items before using the 'whereIn' query
      if (followedUserIds.length > 10) {
        for (int i = 0; i < followedUserIds.length; i += 10) {
          final chunk = followedUserIds.sublist(i, i + 10);
          await _loadPostsForChunk(chunk);
        }
      } else {
        await _loadPostsForChunk(followedUserIds);
      }
    } catch (e) {
      print("Error loading followed user posts: $e");
      emit(PostLoadFailure("Failed to load posts: $e"));
    }
  }

  Future<void> _loadPostsForChunk(List<String> followedUserIds) async {
    try {
      final postsSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', whereIn: followedUserIds)
          .get();

      List<PostModel> posts = postsSnapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      emit(PostLoadSuccess(posts));
    } catch (e) {
      print("Error loading posts for chunk: $e");
      emit(PostLoadFailure("Failed to load posts for chunk: $e"));
    }
  }



  // Function to like/unlike a post with instant UI update
  Future<void> toggleLikePost(PostModel post, String userId) async {
    try {
      // Check if the post is currently liked by the user
      final isLiked = post.likes!.contains(userId);

      // Update the local post model by toggling the like status
      if (isLiked) {
        post.likes!.remove(userId); // Remove user ID from likes
      } else {
        post.likes!.add(userId); // Add user ID to likes
      }

      // Reference to the Firestore document for the main posts collection
      DocumentReference postRef =
          _firestore.collection('posts').doc(post.postId);

      // Reference to the Firestore document in the user's subcollection
      DocumentReference userPostRef = _firestore
          .collection('users')
          .doc(post.uid) // Assuming each post has a userId field
          .collection('userPosts')
          .doc(post.postId);

      // Update the Firestore document accordingly in both collections
      if (isLiked) {
        await postRef.update({
          'likes': FieldValue.arrayRemove([userId]),
          // Remove like from main posts collection
        });
        await userPostRef.update({
          'likes': FieldValue.arrayRemove([userId]),
          // Remove like from userPosts subcollection
        });
      } else {
        await postRef.update({
          'likes': FieldValue.arrayUnion([userId]),
          // Add like to main posts collection
        });
        await userPostRef.update({
          'likes': FieldValue.arrayUnion([userId]),
          // Add like to userPosts subcollection
        });
      }
    } catch (e) {
      // Emit an error state if there's an issue
      emit(PostLoadFailure('Failed to toggle like: $e'));
    }
  }

  Future<void> toggleFavoritePost(PostModel post) async {
    try {
      // Get the currently logged-in user ID
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the logged-in user's favorites collection
      final userRef =
      FirebaseFirestore.instance.collection('users').doc(currentUserId);
      final favoritesRef = userRef.collection('favorites');

      // Check if the post is already saved
      final docSnapshot = await favoritesRef.doc(post.postId).get();
      bool isCurrentlySaved = docSnapshot.exists;

      if (isCurrentlySaved) {
        // Post is already in favorites, remove it
        await favoritesRef.doc(post.postId).delete();
        print("Post removed from favorites");
      } else {
        // Post is not in favorites, add it
        await favoritesRef.doc(post.postId).set({
          'postId': post.postId,
          'ownerId': post.uid, // ID of the post owner
          'mediaUrls': post.mediaUrls,
          'createdAt': FieldValue.serverTimestamp(), // Store server timestamp
        });
        print("Post added to favorites");
      }

      // Toggle the 'isSaved' status locally in the post
      post.isSaved = !isCurrentlySaved;

      // Emit a state to update the UI
      emit(PostSavedToggle(postId: post.postId!, isSaved: post.isSaved));
    } catch (e) {
      print("Error toggling favorite post: $e");
      emit(PostLoadFailure("Failed to toggle favorite post: $e"));
    }
  }

  //
  Future<void> fetchFavoritePosts() async {
    emit(PostLoading());
    try {
      // Get the currently logged-in user ID
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Reference to the logged-in user's favorites collection
      final userRef =
      FirebaseFirestore.instance.collection('users').doc(currentUserId);
      final favoritesRef = userRef.collection('favorites');

      // Fetch all documents from the favorites subcollection
      final querySnapshot = await favoritesRef.get();

      // Get the list of favorite post IDs
      final favoritePostIds = querySnapshot.docs.map((doc) => doc.id).toList();

      // If no favorite posts exist, emit an empty list
      if (favoritePostIds.isEmpty) {
        emit(PostLoadSuccess([]));
        return;
      }

      // Reference to the general posts collection
      final postsRef = FirebaseFirestore.instance.collection('posts');

      // Fetch posts from the general posts collection using the favorite post IDs
      final postsQuerySnapshot = await postsRef
          .where(FieldPath.documentId, whereIn: favoritePostIds)
          .orderBy('createdAt', descending: true)
          .get();

      // Convert each document to a PostModel using fromMap
      List<PostModel> favoritePosts = postsQuerySnapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();

      emit(PostLoadSuccess(favoritePosts));
    } catch (e) {
      print("Error fetching favorite posts: $e");
      emit(PostLoadFailure(e.toString()));
    }
  }



}
