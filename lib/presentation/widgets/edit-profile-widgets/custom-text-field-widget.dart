import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFieldWidget extends StatefulWidget {
  final TextEditingController? controller;
  String? title;
  String? hint;

   CustomTextFieldWidget({super.key, this.controller,required this.title,required this.hint});

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.h,
      width: 375.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("${widget.title}",style: TextStyle(fontSize: 15.sp),),
          Padding(
            padding:  EdgeInsets.only(right: 40.w),
            child: SizedBox(
              height: 48.h,
              width: 180.w,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    hintStyle: TextStyle(fontSize: 12.sp)
                  ),
                  controller: widget.controller,
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
