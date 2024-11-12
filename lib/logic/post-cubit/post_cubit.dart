import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

import '../../data/models/post-model.dart';
// Import your PostModel

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  Future<void> uploadPost({
    required String uid,
    required File imageFile,
    required String description,
    required String location,
    required String username,
    required String userImage,
  }) async {
    emit(PostUploading());

    try {
      // Step 1: Upload image to Firebase Storage
      String imageUrl = await _uploadImageToStorage(uid, imageFile);

      // Step 2: Save post data to Firestore
      String postId = FirebaseFirestore.instance.collection('posts').doc().id;
      DateTime now = DateTime.now();

      PostModel post = PostModel(
        uid: uid,
        postImage: imageUrl,
        description: description,
        location: location,
        username: username,
        userImage: userImage
      );

      await FirebaseFirestore.instance.collection('posts').doc(postId).set({
        ...post.toMap(),
        "date": now.toIso8601String(),
      });

      // Step 3: Save simplified post data to the user's subcollection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('posts')
          .doc(postId) // Same postId to link both entries
          .set({
        "postImage": imageUrl,
        "description": description,
        "location": location,
        "date": now.toIso8601String(),
      });

      emit(PostUploadSuccess(imageUrl));
    } catch (e) {
      emit(PostUploadFailure(e.toString()));
    }
  }

  Future<String> _uploadImageToStorage(String uid, File imageFile) async {
    try {
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('posts')
          .child(uid)
          .child(DateTime.now().millisecondsSinceEpoch.toString());

      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }
}
