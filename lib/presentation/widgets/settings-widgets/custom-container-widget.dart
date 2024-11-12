import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatefulWidget {
  String? imageIcon;
  String? title;

   CustomContainer({super.key,required this.imageIcon,required this.title});

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Row(
        children: [
          Image.asset(
            "${widget.imageIcon}",
            width: 24.w,
            height: 24.h,
          ),
          SizedBox(
            width: 15.w,
          ),
           Text(
            "${widget.title}",
            style:  TextStyle(fontWeight: FontWeight.bold,fontSize: 12.sp),
          ),
          const Spacer(),
           Icon(Icons.arrow_forward_ios_rounded,size: 15.sp,)
        ],
      ),
    );
  }
}
