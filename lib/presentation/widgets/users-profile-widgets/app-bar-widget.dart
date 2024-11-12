import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBarUsersProfile extends StatefulWidget {
  const CustomAppBarUsersProfile({super.key});

  @override
  State<CustomAppBarUsersProfile> createState() =>
      _CustomAppBarUsersProfileState();
}

class _CustomAppBarUsersProfileState extends State<CustomAppBarUsersProfile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          Icons.arrow_back_ios_new,
          size: 24.sp,
        ),
        Text(
          "username",
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Icon(
              Icons.notifications_none,
              size: 24.sp,
            ),
            Icon(
              Icons.more_horiz,
              size: 24.sp,
            ),
          ],
        )

      ],
    );
  }
}
