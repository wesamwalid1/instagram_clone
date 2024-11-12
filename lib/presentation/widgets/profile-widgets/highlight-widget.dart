import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class highlights extends StatefulWidget {
  const highlights({super.key});

  @override
  State<highlights> createState() => _highlightsState();
}

class _highlightsState extends State<highlights> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      width: 390.w,
      child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal:8.w),
                child: Container(
                  height: 60.h,
                  width: 60.w,
                  //padding: const EdgeInsets.symmetric(horizontal: 15),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/post.jpeg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 5.h,),
               Text(
                "Text here",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp),
              )
            ]);
          }),
    );
  }
}
