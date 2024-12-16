import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm(
      {super.key, required this.hint, this.obscureText = false, required this.controller});
  final String hint;
  final bool obscureText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: isDarkMode ? Colors.white54 : const Color.fromRGBO(217, 217, 217, 1),
                width: 2.0.w)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: isDarkMode ? Colors.white : Colors.black, width: 2.0.w)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red, width: 2.0.w)),
        hintText: hint,
        hintStyle: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black54, // Adjust hint color based on theme
        ),
        fillColor: isDarkMode ? Colors.grey[800] : const Color.fromRGBO(217, 217, 217, 1),
        filled: true,
      ),
      controller: controller,
    );
  }
}
