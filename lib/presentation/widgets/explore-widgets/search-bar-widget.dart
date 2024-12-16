import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../screens/explore-screens/search-screen.dart';  // Import your SearchScreen

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    // Determine the theme mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey.shade800 : Colors.grey.shade300;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () {
        // Navigate to the SearchScreen when the search bar is tapped
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchScreen()),
        );
      },
      child: Container(
        height: 35.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            SizedBox(width: 10.w),
            Icon(Icons.search_rounded, color: textColor),  // Adjust icon color based on theme
            SizedBox(width: 10.w),
            Text(
              "Search",
              style: TextStyle(
                color: textColor,  // Adjust text color based on theme
              ),
            ),
          ],
        ),
      ),
    );
  }
}
