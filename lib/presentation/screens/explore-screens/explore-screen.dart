import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/post-cubit/post_cubit.dart';
import '../../../shared/widgets/posts-grid-view-widget.dart';
import '../../widgets/explore-widgets/search-bar-widget.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    context.read<PostCubit>().loadPosts(uid);
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme (dark or light mode)
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Set the background color based on the theme mode
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    // Set text color based on the theme mode
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search bar widget
            Padding(
              padding: EdgeInsets.only(top: 35.h, left: 10.w, right: 10.w),
              child: const SearchBarWidget(),
            ),
            BlocConsumer<PostCubit, PostState>(
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
                        style: TextStyle(fontSize: 18.sp, color: textColor),
                      ),
                    );
                  }

                  return PostsGridViewWidget(
                    title: "Explore",
                    posts: posts,
                  );
                } else if (state is PostLoadFailure) {
                  return Center(
                    child: Text(
                      "Failed to load posts",
                      style: TextStyle(fontSize: 18.sp, color: textColor),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
