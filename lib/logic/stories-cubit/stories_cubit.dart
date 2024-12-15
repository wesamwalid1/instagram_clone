import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/logic/stories-cubit/stories_state.dart';
import 'dart:io';
import '../../../data/models/stories-model.dart';


class StoryCubit extends Cubit<StoryState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  List<StoryModel> stories = [];
  StoryCubit() : super(StoryInitial());

  // Function to add a story
  Future<void> addStory({
    required String userId,
    required String profilePhoto,
    required String username,
    List<XFile>? mediaFiles,
  }) async {
    try {
      emit(StoryLoading());

      // Handle media upload and create a list of media URLs
      List<String> mediaUrls = [];
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (XFile file in mediaFiles) {
          String downloadUrl = await _uploadMedia(file);
          mediaUrls.add(downloadUrl); // Collect URLs
        }
      }

      // Create a new story with a unique ID
      String storyId = _firestore.collection('stories').doc().id;
      StoryModel newStory = StoryModel(
        storyId: storyId,
        userId: userId,
        profilePhoto: profilePhoto,
        username: username,
        mediaUrls: mediaUrls,
        timestamp: DateTime.now(),
        isVideo: mediaFiles?.any((file) => file.mimeType?.startsWith('video') ?? false) ?? false,
        viewers: [],
      );

      // Add the new story to Firestore
      await _firestore.collection('stories').doc(storyId).set(newStory.toMap());

      emit(StoryCreatedSuccess(newStory));
    } catch (e) {
      emit(StoryError('Failed to create story: $e'));
    }
  }


  Future<void> addImagesToStory(String storyId, List<String> newMediaUrls) async {
    try {
      emit(StoryLoading());

      // Fetch the existing story
      DocumentSnapshot storySnapshot = await _firestore.collection('stories').doc(storyId).get();

      if (storySnapshot.exists) {
        // Update existing story's media URLs
        StoryModel existingStory = StoryModel.fromMap(storySnapshot.data() as Map<String, dynamic>);

        // Append new media URLs
        existingStory.mediaUrls!.addAll(newMediaUrls);

        // Update the Firestore document
        await _firestore.collection('stories').doc(storyId).update(existingStory.toMap());

        emit(StoryCreatedSuccess(existingStory)); // Emit the updated story
      } else {
        emit(StoryError('Story not found.'));
      }
    } catch (e) {
      emit(StoryError('Failed to add images to story: $e'));
    }
  }

  // Fetch stories of followed users
  Future<void> fetchStories(List<String> following, String currentUserId) async {
    try {
      emit(StoryLoading());

      QuerySnapshot snapshot = await _firestore
          .collection('stories')
          .where('userId', whereIn: following)
          .get();

      DateTime now = DateTime.now();
      List<StoryModel> stories = [];
      bool userHasStory = false;

      for (var doc in snapshot.docs) {
        StoryModel story = StoryModel.fromMap(doc.data() as Map<String, dynamic>);

        // Check if the story was created within the last 24 hours
        if (story.timestamp != null && now.difference(story.timestamp!).inHours < 24) {
          stories.add(story);
          if (story.userId == currentUserId) {
            userHasStory = true; // Set userHasStory if the current user has a story
          }
        }
      }

      emit(StoriesLoaded(userHasStory: userHasStory, stories: stories));
    } catch (e) {
      emit(StoryError('Failed to fetch stories: $e'));
    }
  }
  // Fetch all available stories
  Future<void> fetchAllStories(String currentUserId) async {
    try {
      emit(StoryLoading());

      QuerySnapshot snapshot = await _firestore.collection('stories').get();

      DateTime now = DateTime.now();
      List<StoryModel> stories = [];
      bool userHasStory = false;

      // First, add the current user's story if it exists
      for (var doc in snapshot.docs) {
        StoryModel story = StoryModel.fromMap(doc.data() as Map<String, dynamic>);

        // Check if the story was created within the last 24 hours
        if (story.timestamp != null && now.difference(story.timestamp!).inHours < 1000) {
          if (story.userId == currentUserId) {
            userHasStory = true; // Set userHasStory if the current user has a story
            stories.insert(0, story); // Insert the current user's story at the start
          } else {
            stories.add(story); // Add other stories to the list
          }
        }
      }

      emit(StoriesLoaded(userHasStory: userHasStory, stories: stories));
    } catch (e) {
      emit(StoryError('Failed to fetch stories: $e'));
    }
  }
  // Add viewer to a story
  Future<void> addViewer(String storyId, String userId) async {
    try {
      DocumentReference storyRef = _firestore.collection('stories').doc(storyId);
      await storyRef.update({
        'viewers': FieldValue.arrayUnion([userId]),
      });
      emit(StoryViewedSuccess());
    } catch (e) {
      emit(StoryError('Failed to add viewer: $e'));
    }
  }




  Future<String> _uploadMedia(XFile file) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = _storage.ref().child("stories/$fileName");
      UploadTask uploadTask = storageRef.putFile(File(file.path));
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload media: $e');
    }
  }
  // Pick multiple media files
  Future<List<XFile>?> pickMediaFiles() async {
    try {
      return await _picker.pickMultiImage(); // Use pickMultiImage to select multiple images
    } catch (e) {
      emit(StoryError('Failed to pick media: $e'));
      return null; // Return null if picking fails
    }
  }
}