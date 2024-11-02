import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfileData extends StatefulWidget {
  const UserProfileData({super.key});

  @override
  State<UserProfileData> createState() => _UserProfileDataState();
}

class _UserProfileDataState extends State<UserProfileData> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          height: 90.h,
          width: 90.w,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Image.asset(
            'assets/images/post.jpeg',
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(width: 45.w,),
        const Column(
          children: [
            Text("1,234",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
            Text("posts",style: TextStyle(fontSize: 14),)
          ],
        ),
        SizedBox(width: 45.w,),
        const Column(
          children: [
            Text("5,678",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
            Text("Followers",style: TextStyle(fontSize: 14),)
          ],
        ),
        SizedBox(width: 45.w,),
        const Column(
          children: [
            Text("9,101",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
            Text("Following",style: TextStyle(fontSize: 14),)
          ],
        ),

      ],
    );
  }
}
