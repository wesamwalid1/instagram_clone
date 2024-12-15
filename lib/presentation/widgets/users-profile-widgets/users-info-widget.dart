import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/auth-model.dart';

class UsersInfo extends StatelessWidget {
  final UserModel user ;
  const UsersInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    String? name = user.name;
    String? bio = user.bio;
    String? website = user.website;
     return SizedBox(
      width: 300.w,
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (name != null && name.isNotEmpty)
            Text(
              name,
              style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
            ),

          if (bio != null && bio.isNotEmpty)
            Text(
              bio,
              style: TextStyle(fontSize: 10.sp),
            ),
          if (website != null && website.isNotEmpty)
            Text(
              website,
              style: TextStyle(fontSize: 10.sp, color: Colors.blue),
            ),
          SizedBox(height: 20.h),

        ],
      ),
    );
  }
}
