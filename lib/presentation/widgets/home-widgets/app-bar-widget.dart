import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomAppBarHomePage extends StatefulWidget {
  const CustomAppBarHomePage({super.key});

  @override
  State<CustomAppBarHomePage> createState() => _CustomAppBarHomePageState();
}

class _CustomAppBarHomePageState extends State<CustomAppBarHomePage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 30.h,
          width: 150.w,
          child: Row(
            children: [
              Image.asset("assets/images/instagram_text_logo.png"),
              const Icon(Icons.keyboard_arrow_down),
            ],
          ),
        ),
        const Spacer(),
        SizedBox(
          height: 30.h,
          width: 150.w,
          child: Row(
            children: [
              SizedBox(
                width: 25.w,
              ),
               Icon(
                Icons.favorite_border,
                size: 30.sp,
              ),
              SizedBox(
                width: 15.w,
              ),
              Image.asset(
                "assets/images/Messenger_icon.png",
                width: 30.w,
                height: 30.h,
              ),
              SizedBox(
                width: 15.w,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, "add");
                },
                child: Image.asset(
                  "assets/images/add_icon.png",
                  width: 30.w,
                  height: 30.h,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
