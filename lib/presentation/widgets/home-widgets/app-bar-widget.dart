import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/presentation/screens/chat-screens/direct-screen.dart';

class CustomAppBarHomePage extends StatefulWidget {
  const CustomAppBarHomePage({super.key});

  @override
  State<CustomAppBarHomePage> createState() => _CustomAppBarHomePageState();
}

class _CustomAppBarHomePageState extends State<CustomAppBarHomePage> {
  @override
  Widget build(BuildContext context) {
    // Get the current theme (dark or light mode)
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Set the icon color based on the theme mode
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final logoImage = isDarkMode
        ? "assets/images/instagram_text_logo_dark.png"  // Use a dark version of the logo
        : "assets/images/instagram_text_logo.png";      // Use the default logo

    return Row(
      children: [
        SizedBox(
          height: 30.h,
          width: 150.w,
          child: Row(
            children: [
              // Apply color filter to the logo if needed
              Image.asset(logoImage),
              Icon(Icons.keyboard_arrow_down, color: iconColor), // Icon color based on theme
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
                color: iconColor,
              ),
              SizedBox(
                width: 15.w,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DirectScreen(),
                    ),
                  );
                },
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    iconColor.withOpacity(0.7), // Adjust opacity or color as needed
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    "assets/images/Messenger_icon.png",
                    width: 30.w,
                    height: 30.h,
                  ),
                ),
              ),
              SizedBox(
                width: 15.w,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "add");
                },
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    iconColor.withOpacity(0.7), // Adjust opacity or color as needed
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(
                    "assets/images/add_icon.png",
                    width: 30.w,
                    height: 30.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
