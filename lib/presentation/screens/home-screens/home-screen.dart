import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/presentation/widgets/home-widgets/app-bar-widget.dart';
import 'package:instagramclone/presentation/widgets/home-widgets/posts-list-view-widget.dart';
import 'package:instagramclone/presentation/widgets/home-widgets/stories-list-view-widget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: const EdgeInsets.only(top: 60,left: 10,right: 10),
            child: const CustomAppBarHomePage(),
          ),
           SizedBox(height: 20.h,),
          const CustomStoriesListView(),
           CustomPostsListView(),
        ],
      ),
    ));
  }
}
