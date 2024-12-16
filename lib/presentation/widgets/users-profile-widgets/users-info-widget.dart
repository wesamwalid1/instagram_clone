import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/auth-model.dart';

class UsersInfo extends StatelessWidget {
  final UserModel user;
  const UsersInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    String? name = user.name;
    String? bio = user.bio;
    String? website = user.website;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 300.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (name != null && name.isNotEmpty)
            Text(
              name,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,  // Text color based on theme
              ),
            ),
          if (bio != null && bio.isNotEmpty)
            Text(
              bio,
              style: TextStyle(
                fontSize: 10.sp,
                color: isDarkMode ? Colors.white70 : Colors.black87,  // Text color based on theme
              ),
            ),
          if (website != null && website.isNotEmpty)
            Text(
              website,
              style: TextStyle(
                fontSize: 10.sp,
                color: isDarkMode ? Colors.blueAccent : Colors.blue,  // Website color based on theme
              ),
            ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
