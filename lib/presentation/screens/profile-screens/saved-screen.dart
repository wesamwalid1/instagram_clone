import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/logic/post-cubit/post_cubit.dart';
import 'package:instagramclone/main.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Saved",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15.sp),),
        centerTitle: true,
      ),
      body: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          if (state is PostLoadFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
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
                  "No posts yet",
                  style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                ),
              );
            }

            return PostsGridViewWidget(
              title: "Saved",
              posts: posts,
            );
          } else if (state is PostLoadFailure) {
            return const Center(
              child: Text("Failed to load posts"),
            );
          } else {
            return const SizedBox();
          }
        },
      ),

    );
  }
}
