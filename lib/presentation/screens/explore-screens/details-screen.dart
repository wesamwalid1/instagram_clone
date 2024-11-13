import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/explore-widgets/explore-posts-list-view-widget.dart';

class DetailsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> posts;
  final Map<String, dynamic> selectedPost;

  const DetailsScreen({
    Key? key,
    required this.posts,
    required this.selectedPost,
  }) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late List<Map<String, dynamic>> reorderedPosts;

  @override
  void initState() {
    super.initState();

    // Place selected post at the top, followed by the rest
    reorderedPosts = [
      widget.selectedPost,
      ...widget.posts.where((post) => post != widget.selectedPost)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Explore",
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new, size: 20.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(color: Colors.grey.shade200),
            ExplorePostsListView(posts: reorderedPosts), // Use reordered list
          ],
        ),
      ),
    );
  }
}
