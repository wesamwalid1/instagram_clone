import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/stories-model.dart';
import '../../../logic/auth-cubit/auth_cubit.dart';
import '../../../logic/stories-cubit/stories_cubit.dart';
import '../../../logic/stories-cubit/stories_state.dart';

class AddStoryScreen extends StatefulWidget {
  @override
  _AddStoryScreenState createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    context.read<AuthCubit>().fetchUserInfo(uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoryCubit, StoryState>(
      listener: (context, state) {
        if (state is StoryCreatedSuccess) {
          // If the story was added successfully, navigate back
          Navigator.pushReplacementNamed(context, 'main_screen');
        } else if (state is StoryError) {
          // Handle errors if the story addition failed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add Story')),
        body: BlocBuilder<StoryCubit, StoryState>(
          builder: (context, state) {
            if (state is StoryLoading) {
              // Show a progress indicator while uploading
              return const Center(child: CircularProgressIndicator());
            }

            return Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Pick images or videos
                  final List<XFile>? mediaFiles =
                      await _picker.pickMultiImage();
                  if (mediaFiles != null && mediaFiles.isNotEmpty) {
                    // Fetch user info from UserCubit
                    final authState = context.read<AuthCubit>().state;

                    if (authState is AuthSuccess &&
                        authState.userModel != null) {
                      final currentUserId = authState.user.uid;
                      final profilePhoto = authState.userModel!.profilePhoto;
                      final username = authState.userModel!.username;

                      // Check if a story already exists for the current user
                      final existingStory =
                          context.read<StoryCubit>().stories.firstWhere(
                                (story) => story.userId == currentUserId,
                                orElse: () => StoryModel(
                                  storyId: '',
                                  userId: currentUserId,
                                  profilePhoto: profilePhoto,
                                  username: username,
                                  mediaUrls: [],
                                  timestamp: DateTime.now(),
                                  isVideo: false,
                                  viewers: [],
                                ),
                              );

                      if (existingStory.storyId!.isNotEmpty) {
                        // If a story exists, add images to the existing story
                        context.read<StoryCubit>().addImagesToStory(
                              existingStory.storyId.toString(),
                              mediaFiles.map((file) => file.path).toList(),
                            );
                      } else {
                        // Create a new story
                        context.read<StoryCubit>().addStory(
                              userId: currentUserId,
                              profilePhoto: profilePhoto.toString(),
                              username: username.toString(),
                              mediaFiles: mediaFiles,
                            );
                      }
                    } else if (authState is AuthFailure) {
                      // Handle errors if needed
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(authState.error)),
                      );
                    }
                  }
                },
                child: const Text('Select Media'),
              ),
            );
          },
        ),
      ),
    );
  }
}