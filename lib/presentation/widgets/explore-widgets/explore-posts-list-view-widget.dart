import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExplorePostsListView extends StatelessWidget {
  final List<Map<String, dynamic>> posts;

  const ExplorePostsListView({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts.length,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var post = posts[index];
        // Using default values or handling null fields
        String postImage = post['postImage'] ?? '';
        String description = post['description'] ?? 'No description';
        String location = post['location'] ?? 'Unknown location';
        String username = post['username'] ?? 'Unknown username';
        String userImage = post['userImage'] ?? '';

        return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      height: 40.h,
                      width: 40.w,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.network(
                        userImage,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12.sp),
                        ),
                        Text(
                          location,
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.more_horiz, size: 24.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 390.h,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  postImage,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.only(left: 15.w, right: 15.w),
                child: Row(
                  children: [
                    Icon(Icons.favorite_border, size: 30.sp),
                    SizedBox(width: 10.w),
                    Image.asset("assets/images/comment.png", width: 24.w, height: 24.h),
                    SizedBox(width: 10.w),
                    Image.asset("assets/images/share.png", width: 24.w, height: 24.h),
                    const Spacer(),
                    Image.asset("assets/images/bookmark.png", width: 24.w, height: 24.h),
                  ],
                ),
              ),
              SizedBox(height: 5.h),
              Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Likes",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13.sp),
                    ),
                    Row(
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          description,
                          style: TextStyle(fontSize: 13.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
