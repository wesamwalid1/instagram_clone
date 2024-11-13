import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/explore-widgets/explore-posts-grid-view-widget.dart';
import '../../widgets/explore-widgets/search-bar-widget.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: EdgeInsets.only(top: 35.h, left: 10.w, right: 10.w),
              child: const SearchBarWidget()
            ),
            // BlocBuilder to handle the loading and displaying of posts
            const ExplorePostsGridViewWidget(),
          ],
        ),
      ),
    );
  }
}
