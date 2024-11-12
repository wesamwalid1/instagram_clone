import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsersProfileData extends StatefulWidget {
  const UsersProfileData({super.key});

  @override
  State<UsersProfileData> createState() => _UsersProfileDataState();
}

class _UsersProfileDataState extends State<UsersProfileData> {
  @override
  Widget build(BuildContext context) {
    String profilePhotoUrl = 'assets/images/default_profile.png';
    return Row(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          height: 70.h,
          width: 70.w,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Image.asset(
            profilePhotoUrl,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 10.w,),
        Column(
          children: [
            Text("1,234",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),),
            Text("posts",style: TextStyle(fontSize: 14.sp),)
          ],
        ),
        SizedBox(width: 45.w,),
        Column(
          children: [
            Text("5,678",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),),
            Text("Followers",style: TextStyle(fontSize: 14.sp),)
          ],
        ),
        SizedBox(width: 45.w,),
        Column(
          children: [
            Text("9,101",style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.bold),),
            Text("Following",style: TextStyle(fontSize: 14.sp),)
          ],
        ),

      ],
    );
  }
}
