import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/main.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 30.h,
          width: 300.w,
          color: const Color.fromRGBO(239, 239, 239, 1),
          child: const Center(child: Text("Edit profile",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),)),

        ),
        SizedBox(width: 5.w,),
        Container(
          height: 30.h,
          width: 32.w,
          color: const Color.fromRGBO(239, 239, 239, 1),
          child:Image.asset("assets/images/add-people-icon.png",)

        )
      ],
    );
  }
}
