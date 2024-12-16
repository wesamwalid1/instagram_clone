import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/generated/l10n.dart';

class CustomAppBarEditProfileScreen extends StatefulWidget {
  final VoidCallback onCancel;
  final VoidCallback onDone;
  const CustomAppBarEditProfileScreen({super.key, required this.onCancel, required this.onDone});

  @override
  State<CustomAppBarEditProfileScreen> createState() => _CustomAppBarEditProfileScreenState();
}

class _CustomAppBarEditProfileScreenState extends State<CustomAppBarEditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: widget.onCancel,
            child: Text(
              S.of(context).cancel,
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          Text(
            S.of(context).Edit_Profile,
            style: TextStyle(
              fontSize: 16.sp,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          GestureDetector(
            onTap: widget.onDone,
            child: Text(
              S.of(context).Done,
              style: TextStyle(
                fontSize: 16.sp,
                color: isDarkMode
                    ? Colors.blue[200]
                    : const Color.fromRGBO(56, 151, 240, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
