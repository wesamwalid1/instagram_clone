import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomContainer extends StatefulWidget {
  final String? imageIcon;
  final String? title;

  CustomContainer({super.key, required this.imageIcon, required this.title});

  @override
  State<CustomContainer> createState() => _CustomContainerState();
}

class _CustomContainerState extends State<CustomContainer> {
  @override
  Widget build(BuildContext context) {
    // Check the current theme (dark or light mode)
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Set colors based on the theme
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      color: isDarkMode ? Colors.grey[850] : Colors.transparent, // Optional: Container background color
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w), // Add padding for better spacing
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
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
              color: textColor, // Text color based on theme
            ),
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 15.sp,
            color: iconColor, // Icon color based on theme
          ),
        ],
      ),
    );
  }
}
