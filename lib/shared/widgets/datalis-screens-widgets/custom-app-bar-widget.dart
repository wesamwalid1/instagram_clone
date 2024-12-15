import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/main.dart';

class CustomAppBarWidget extends StatefulWidget {
  final String? username;
  final String title;
  const CustomAppBarWidget({super.key,   this.username, required this.title});

  @override
  State<CustomAppBarWidget> createState() => _CustomAppBarWidgetState();
}

class _CustomAppBarWidgetState extends State<CustomAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 10.w,),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
              child: Icon(Icons.arrow_back_ios_new,size: 20.sp,)),

          if(widget.username!=null)
            Expanded(
              child: Center(
                child: Padding(
                  padding:  EdgeInsets.only(right: 30.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.username!,
                        style: TextStyle(fontSize: 12.sp),
                      ),
                      Text(
                        widget.title,
                        style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Center(
                child: Padding(
                  padding:  EdgeInsets.only(right: 30.w),
                  child: Text(
                    widget.title,
                    style:
                    TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
