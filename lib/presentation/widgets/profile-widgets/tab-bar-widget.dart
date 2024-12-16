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
          _buildTabBar(),
          Expanded(child: _buildTabBarView()),
        ],
      ),
    );
  }

  // TabBar widget to handle icon selection logic
  TabBar _buildTabBar() {
    return TabBar(
      indicatorColor: Colors.black87,
      onTap: (index) {
        setState(() {
          _selectedTabIndex = index; // Update the selected tab index
        });
      },
      tabs: [
        _buildTab(0, "assets/images/parent_components.png", "assets/images/iconsNotSelected/grid-not-select.png"),
        _buildTab(1, "assets/images/reels-icon.png", "assets/images/iconsNotSelected/reels-not-select.png"),
        _buildTab(2, "assets/images/mentions.png", "assets/images/iconsNotSelected/mentions-not-select.png"),
      ],
    );
  }

  // Helper method to build each tab with selected and non-selected icons
  Tab _buildTab(int index, String selectedIcon, String unselectedIcon) {
    return Tab(
      icon: _selectedTabIndex == index
          ? Image.asset(selectedIcon)
          : Image.asset(unselectedIcon),
    );
  }

  // TabBarView widget to display content based on selected tab
  Widget _buildTabBarView() {
    return TabBarView(
      children: [
        _buildUserPostsGrid(), // First Tab: User's posts
        Center(child: Text("Reels Tab")), // Second Tab
        Center(child: Text("Mentions Tab")), // Third Tab
      ],
    );
  }

  // Method to display the user's posts grid
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

          if (posts.isEmpty) {
            return Center(
              child: Text(
                "No posts yet",
                style: TextStyle(fontSize: 18.sp, color: Colors.grey),
              ),
            );
          }

          return PostsGridViewWidget(
            title: 'Posts',
            posts: posts,
            username: posts[0].username,
          );
        } else if (state is PostLoadFailure) {
          return const Center(
            child: Text("Failed to load posts"),
          );
        } else {
          return const SizedBox(); // Handle other states if necessary
        }
      },
    );
  }
}
