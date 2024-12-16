import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/logic/auth-cubit/auth_cubit.dart';
import 'package:instagramclone/logic/post-cubit/post_cubit.dart';
import 'package:instagramclone/presentation/widgets/profile-widgets/app-bar-widget.dart';
import 'package:instagramclone/presentation/widgets/profile-widgets/user-info-widget.dart';
import '../../widgets/profile-widgets/edit-profile-widget.dart';
import '../../widgets/profile-widgets/highlight-widget.dart';
import '../../widgets/profile-widgets/tab-bar-widget.dart';
import '../../widgets/profile-widgets/user-profile-data-widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    context.read<AuthCubit>().fetchUserInfo(uid);
    context.read<PostCubit>().loadUserPosts(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,  // Use theme's background color
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h), // Adjusted app bar height using ScreenUtil
        child: Padding(
          padding:  EdgeInsets.only(top: 30.h,left: 15.w,right: 15.w),
          child: CustomAppBarProfilePage(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w), // Reduced top padding for compactness
              child: Column(
                children: [
                  const UserProfileData(),
                  SizedBox(height: 12.h), // Adjusted spacing between widgets
                  const UsersInfo(),
                  SizedBox(height: 12.h),
                  const EditProfile(),
                  SizedBox(height: 25.h),
                  const Highlights(),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 500.h,
              child: const TabBarProfilePage(),
            ),
          ],
        ),
      ),
    );
  }
}
