import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBarEditProfileScreen extends StatefulWidget {
  const CustomAppBarEditProfileScreen({super.key});

  @override
  State<CustomAppBarEditProfileScreen> createState() => _CustomAppBarEditProfileScreenState();
}

class _CustomAppBarEditProfileScreenState extends State<CustomAppBarEditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               GestureDetector(
                 onTap: (){},
                   child: Text("Cancel",style: TextStyle(fontSize: 16.sp),)),
               Text("Edit Profile",style: TextStyle(fontSize: 16.sp),),
               GestureDetector(
                 onTap:(){} ,
                   child: Text("Done",style: TextStyle(fontSize: 16.sp,color:const Color.fromRGBO(56, 151, 240, 1)),)),
             ],
           ),
    );
  }
}
