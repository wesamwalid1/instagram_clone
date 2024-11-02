import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBarProfilePage extends StatefulWidget {
  const CustomAppBarProfilePage({super.key});

  @override
  State<CustomAppBarProfilePage> createState() => _CustomAppBarProfilePageState();
}

class _CustomAppBarProfilePageState extends State<CustomAppBarProfilePage> {
  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        const Text("Wesam.Walid1",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
        const Spacer(),
        Image.asset(
          "assets/images/add_icon.png",
          width: 24.w,
          height: 24.h,
        ),
        SizedBox(width: 10.w,),
        const Icon(
          Icons.menu,
          size: 30,
        ),
      ],
    );
  }
}
