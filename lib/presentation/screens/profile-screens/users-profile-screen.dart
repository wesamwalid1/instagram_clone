import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/presentation/widgets/users-profile-widgets/app-bar-widget.dart';
import 'package:instagramclone/presentation/widgets/users-profile-widgets/users-highlight-widget.dart';
import 'package:instagramclone/presentation/widgets/users-profile-widgets/users-tab-bar-widget.dart';
import '../../widgets/users-profile-widgets/users-custom-buttons-widget.dart';
import '../../widgets/users-profile-widgets/users-info-widget.dart';
import '../../widgets/users-profile-widgets/users-profile-data-widget.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 60,left: 17,right: 17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppBarUsersProfile(),
              SizedBox(height: 10.h,),
              const UsersProfileData(),
              SizedBox(height: 10.h,),
              const UsersInfo(),
              const UsersCustomButtons(),
              SizedBox(height: 20.h,),
              const UsersHighLight(),
              SizedBox(height:500.h,child: const UsersTabBar())
            ],
          ),
        ),
      ),

    );
  }
}
