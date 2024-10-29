import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/posts.dart';
import 'package:instagramclone/stories.dart';

class homeScreen extends StatelessWidget {
  final List _posts = [
    'post 1',
    'post 2',
    'post 3',
    'post 4',
  ];

  // final List _stories = [
  //   'story 1',
  //   'story 2',
  //   'story 3',
  //   'story 4',
  //   'story 5',
  //   'story 6',
  //   'story 7',
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 65, left: 20),
            child: Row(
              children: [
                SizedBox(
                    height: 30.h,
                    width: 150.w,
                    child: Row(
                      children: [
                        Image.asset("assets/images/instagram_text_logo.png"),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    )),
                const Spacer(),
                SizedBox(
                  height: 24.h,
                  width: 120.w,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 25.w,
                      ),
                      const Icon(
                        Icons.favorite_border,
                        size: 30,
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Image.asset(
                        "assets/images/Messenger_icon.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      Image.asset(
                        "assets/images/add_icon.png",
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 17.h,),
          //instagram stories
          Expanded(
              child: ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return const Column(
                      children: [
                        stories(),
                        Text("Wesam.Walid1",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13),)
                      ],
                    );
                  })
          ),


          //instagram posts
          Expanded(
            child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  return posts(
                    text: _posts[index],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
