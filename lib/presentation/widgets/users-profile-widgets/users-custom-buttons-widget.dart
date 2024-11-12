import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UsersCustomButtons extends StatefulWidget {
  const UsersCustomButtons({super.key});

  @override
  State<UsersCustomButtons> createState() => _UsersCustomButtonsState();
}

class _UsersCustomButtonsState extends State<UsersCustomButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "edit_profile");
          },
          child: Container(
            height: 30.h,
            width: 366.w,
            color: const Color.fromRGBO(31, 161, 255, 1),
            child: const Center(
                child: Text(
              "Follow",
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )),
          ),
        ),
        SizedBox(
          height: 10..h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 30.h,
                width: 95.w,
                color: const Color.fromRGBO(239, 239, 239, 1),
                child: Center(
                    child: Text(
                  "Message",
                  style:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                ))),
            Container(
                height: 30.h,
                width: 95.w,
                color: const Color.fromRGBO(239, 239, 239, 1),
                child: Center(
                    child: Text(
                  "Subscribe",
                  style:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                ))),
            Container(
                height: 30.h,
                width: 95.w,
                color: const Color.fromRGBO(239, 239, 239, 1),
                child: Center(
                    child: Text(
                  "Contact",
                  style:
                      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                ))),
            Container(
                height: 30.h,
                width: 32.w,
                color: const Color.fromRGBO(239, 239, 239, 1),
                child: Image.asset(
                  "assets/images/add-people-icon.png",
                )),
          ],
        )
      ],
    );
  }
}
