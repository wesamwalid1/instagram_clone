import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabBarProfilePage extends StatefulWidget {

  const TabBarProfilePage({super.key});

  @override
  _TabBarProfilePageState createState() => _TabBarProfilePageState();
}

class _TabBarProfilePageState extends State<TabBarProfilePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            indicatorColor: Colors.black87,
            tabs: [
              Tab(
                icon: Image.asset("assets/images/parent_components.png"),
              ),
              Tab(
                icon: Image.asset("assets/images/reels-icon.png"),
              ),
              Tab(
                icon: Image.asset("assets/images/mentions.png"),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildUserPostsGrid(), // First Tab: User's posts
                Center(child: Text("Tab 2")),
                Center(child: Text("Tab 3")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserPostsGrid() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('posts')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Check if there are no posts
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return  Center(
            child: Text(
              "No posts yet",
              style: TextStyle(fontSize: 18.sp, color: Colors.grey),
            ),
          );
        }

        final posts = snapshot.data!.docs;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // Number of columns in the grid
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return Image.network(
              post['postImage'],
              fit: BoxFit.cover,
            );
          },
        );
      },
    );
  }
}
