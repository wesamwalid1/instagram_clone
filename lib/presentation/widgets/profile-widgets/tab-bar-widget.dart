import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/post-cubit/post_cubit.dart';
import '../../../shared/widgets/posts-grid-view-widget.dart';

class TabBarProfilePage extends StatefulWidget {
  const TabBarProfilePage({super.key});

  @override
  _TabBarProfilePageState createState() => _TabBarProfilePageState();
}

class _TabBarProfilePageState extends State<TabBarProfilePage> {
  int _selectedTabIndex = 0; // Track the selected tab index

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    context.read<PostCubit>().loadUserPosts(uid);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: _selectedTabIndex,
      child: Column(
        children: [
          TabBar(
            indicatorColor: Colors.black87,
            onTap: (index) {
              setState(() {
                _selectedTabIndex = index; // Update the selected tab index
              });
            },
            tabs: [
              Tab(
                  icon: _selectedTabIndex == 0
                      ? Image.asset("assets/images/parent_components.png")
                      : Image.asset(
                          "assets/images/iconsNotSelected/grid-not-select.png")),
              Tab(
                icon: _selectedTabIndex == 1
                    ? Image.asset(
                        "assets/images/reels-icon.png") // Selected state
                    : Image.asset(
                        "assets/images/iconsNotSelected/reels-not-select.png"), // Not selected state
              ),
              Tab(
                  icon: _selectedTabIndex == 2
                      ? Image.asset(
                          "assets/images/mentions.png",
                          width: 30.w,
                          height: 30.h,
                        )
                      : Image.asset(
                          "assets/images/iconsNotSelected/mentions-not-select.png")),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildUserPostsGrid(), // First Tab: User's posts
                Center(child: Text("Tab 2")), // Second Tab
                Center(child: Text("Tab 3")), // Third Tab
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserPostsGrid() {
    return BlocConsumer<PostCubit, PostState>(
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
          final username = state.posts[0].username;

          if (posts.isEmpty) {
            return Center(
              child: Text(
                "No posts yet",
                style: TextStyle(fontSize: 18.sp, color: Colors.grey),
              ),
            );
          }

          return PostsGridViewWidget(
            title: 'posts',
            posts: posts,
            username: username,
          );
        } else if (state is PostLoadFailure) {
          return const Center(
            child: Text("Failed to load posts"),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

