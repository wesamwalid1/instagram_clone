import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(top: 45.h,left: 10.w,right: 10.w),
              child: Column(children: [
                const CustomAppBarProfilePage(),
                SizedBox(height: 10.h,),
                const UserProfileData(),
                SizedBox(height: 10.h,),
                const UserInfo(),
                SizedBox(height: 10.h,),
                const EditProfile(),
                SizedBox(height: 20.h,),
                const highlights(),
              ],),
            ),

            SizedBox(height: 10.h,),
            SizedBox(height:500.h,child:  TabBarProfilePage())
          ],
        ),
      ),

    );
  }
}
