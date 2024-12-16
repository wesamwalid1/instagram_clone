import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/auth-model.dart';

class CustomAppBarUsersProfile extends StatelessWidget {
  final UserModel user;
  const CustomAppBarUsersProfile({Key? Key, required this.user}) : super(key: Key);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 24.sp,
            color: isDarkMode ? Colors.white : Colors.black,  // Icon color based on theme
          ),
        ),
        Spacer(),
        Text(
          user.username ?? 'username',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black,  // Text color based on theme
          ),
        ),
        Spacer(),
        Row(
          children: [
            Icon(
              Icons.notifications_none,
              size: 24.sp,
              color: isDarkMode ? Colors.white : Colors.black,  // Icon color based on theme
            ),
            Icon(
              Icons.more_horiz,
              size: 24.sp,
              color: isDarkMode ? Colors.white : Colors.black,  // Icon color based on theme
            ),
          ],
        ),
      ],
    );
  }
}
