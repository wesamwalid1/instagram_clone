import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Highlights extends StatefulWidget {
  const Highlights({super.key});

  @override
  State<Highlights> createState() => _HighlightsState();
}

class _HighlightsState extends State<Highlights> {
  // Sample data for the highlights (you can replace this with dynamic data later)
  final List<Map<String, String>> highlightsData = List.generate(
    10,
        (index) => {
      'image': 'assets/images/post.jpeg', // Replace with dynamic image URL or asset
      'title': 'Highlight $index', // Replace with dynamic text
    },
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      width: 390.w,
      child: ListView.builder(
        itemCount: highlightsData.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final highlight = highlightsData[index];
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Container(
                  height: 60.h,
                  width: 60.w,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(2.w, 2.h),
                        blurRadius: 5.r,
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 3.w),
                  ),
                  child: Image.asset(
                    highlight['image']!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                highlight['title']!,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10.sp,
                  overflow: TextOverflow.ellipsis, // Handles long titles
                ),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }
}
