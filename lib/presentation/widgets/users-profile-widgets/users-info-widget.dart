import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsersInfo extends StatefulWidget {
  const UsersInfo({super.key});

  @override
  State<UsersInfo> createState() => _UsersInfoState();
}

class _UsersInfoState extends State<UsersInfo> {
  @override
  Widget build(BuildContext context) {
     return SizedBox(
      width: 300.w,
      height: 80.h,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "name",
            style:  TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            "bio",
            style: TextStyle(fontSize: 13.sp),
          ),
          Text(
            "website",
            style: TextStyle(fontSize: 13.sp),
          )
        ],
      ),
    );
  }
}
