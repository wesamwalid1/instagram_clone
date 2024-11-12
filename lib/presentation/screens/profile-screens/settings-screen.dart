import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/presentation/widgets/settings-widgets/log-out-widget.dart';
import '../../widgets/settings-widgets/custom-container-widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Settings',style: TextStyle(fontSize: 15.sp,fontWeight: FontWeight.bold),),
        centerTitle: true,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back_ios_new,size: 20.sp,)),
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "How you use instagram",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomContainer(
              imageIcon: "assets/images/bookmark.png",
              title: "Saved",
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Your app and media",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomContainer(
              imageIcon: "assets/images/language-icon.png",
              title: "Language",
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Theme",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomContainer(
              imageIcon: "assets/images/theme.png",
              title: "Theme",
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Login",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12.sp),
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Add account",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15.h,
            ),
            LogOut(),

          ],
        ),
      )),
    );
  }
}
