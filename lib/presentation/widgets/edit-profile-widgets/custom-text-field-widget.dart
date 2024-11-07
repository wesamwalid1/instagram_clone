import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  String? title;

   CustomTextFieldWidget({super.key, this.controller,required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      width: 375.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title",style: TextStyle(fontSize: 15.sp),),
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: SizedBox(
              height: 48.h,
              width: 225.w,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter a search term',
                  ),
                  controller: controller,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
