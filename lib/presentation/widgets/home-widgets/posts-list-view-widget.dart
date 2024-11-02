import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomPostsListView extends StatefulWidget {
  CustomPostsListView({super.key});

  @override
  State<CustomPostsListView> createState() => _CustomPostsListViewState();
}

class _CustomPostsListViewState extends State<CustomPostsListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 5,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15 ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        height: 36.h,
                        width: 36.w,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: Image.asset(
                          'assets/images/post.jpeg',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      const Text(
                        "Wesam.Walid1",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_horiz,
                            size: 24,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                    height: 390.h,
                    width: MediaQuery.of(context).size.width.w,
                    child: Image.asset(
                      'assets/images/post.jpeg',
                      fit: BoxFit.fill,
                    )),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        size: 30,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Image.asset(
                        "assets/images/comment.png",
                        width: 24.w,
                        height: 24.h,
                      ),
                      Image.asset(
                        "assets/images/share.png",
                        width: 24.w,
                        height: 24.h,
                      ),
                      const Spacer(),
                      Image.asset(
                        "assets/images/bookmark.png",
                        width: 24.w,
                        height: 24.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h,),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "100 Likes",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                )
              ],
            ),
          );
        });
  }
}

//Center(
//                   child: Text(
//                     _posts[index],
//                     style: const TextStyle(fontSize: 40),
//                   )),