import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "edit_profile");
          },
          child: Container(
            height: 30.h,
            width: 300.w,
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.1), // Use theme color for background
            child: Center(
              child: Text(
                "Edit profile",
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color, // Use bodyLarge for text color
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 5.w,
        ),
        Container(
          height: 30.h,
          width: 32.w,
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.1), // Same background color as above
          child: Image.asset(
            "assets/images/add-people-icon.png",
          ),
        ),
      ],
    );
  }
}
