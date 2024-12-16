import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/logic/post-cubit/post_cubit.dart';
import 'package:instagramclone/generated/l10n.dart'; // Import for localization

import '../../../shared/widgets/posts-grid-view-widget.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  void initState() {
    super.initState();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      print("Fetching posts for user: $userId");
      context.read<PostCubit>().fetchFavoritePosts();
    } else {
      print("No user is currently logged in.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check the current theme mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define background and text color based on theme
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        title: Text(
          S.of(context).Saved, // Localized string for "Saved"
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
            color: textColor, // Title text color based on theme
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          if (state is PostLoadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black, // Snackbar text color based on theme
                  ),
                ),
                backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300], // Snackbar background color based on theme
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostLoadSuccess) {
            final posts = state.posts;

            if (posts.isEmpty) {
              return Center(
                child: Text(
                  S.of(context).NoPostsYet, // Localized string for "No posts yet"
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: isDarkMode ? Colors.white : Colors.grey, // Text color based on theme
                  ),
                ),
              );
            }

            return PostsGridViewWidget(
              title: S.of(context).Saved, // Localized string for "Saved"
              posts: posts,
            );
          } else if (state is PostLoadFailure) {
            return Center(
              child: Text(
                S.of(context).FailedToLoadPosts, // Localized string for "Failed to load posts"
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black, // Text color based on theme
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
