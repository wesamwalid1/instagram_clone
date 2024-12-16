import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/data/models/auth-model.dart';
import 'package:instagramclone/presentation/widgets/users-profile-widgets/app-bar-widget.dart';
import 'package:instagramclone/presentation/widgets/users-profile-widgets/users-highlight-widget.dart';
import 'package:instagramclone/presentation/widgets/users-profile-widgets/users-tab-bar-widget.dart';
import '../../widgets/users-profile-widgets/users-custom-buttons-widget.dart';
import '../../widgets/users-profile-widgets/users-info-widget.dart';
import '../../widgets/users-profile-widgets/users-profile-data-widget.dart';

class UsersProfileScreen extends StatefulWidget {
  final UserModel user;
  const UsersProfileScreen({super.key, required this.user});

  @override
  State<UsersProfileScreen> createState() => _UsersProfileScreenState();
}

class _UsersProfileScreenState extends State<UsersProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,  // Conditional background color
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 45.h, left: 10.w, right: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBarUsersProfile(user: widget.user),
                  SizedBox(height: 10.h),
                  UsersProfileData(user: widget.user),
                  SizedBox(height: 10.h),
                  UsersInfo(user: widget.user),
                  UsersCustomButtons(user: widget.user),
                  SizedBox(height: 20.h),
                  const UsersHighLight(),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 500.h,
              child: UsersTabBar(user: widget.user),
            ),
          ],
        ),
      ),
    );
  }
}
