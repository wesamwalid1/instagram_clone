import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class posts extends StatelessWidget {
  final String text;

  posts({required this.text}
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8),
      child: Container(
        height: 400.h,
        color: Colors.deepPurple[200],
        child: Center(
            child: Text(
          text,
          style: const TextStyle(fontSize: 40),
        )),
      ),
    );
  }
}
