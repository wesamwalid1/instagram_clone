import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class homeScreen extends StatelessWidget {
  const homeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:  Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 65,left: 20),
            child: Row(
              children: [
                SizedBox(
                  height:30.h,
                  width: 150.w,
                  child:Row(
                    children: [
                      Image.asset("assets/images/instagram_text_logo.png"),
                      const Icon(Icons.keyboard_arrow_down),
                    ],
                  )
                ),
                const Spacer(),
                SizedBox(
                  height: 24.h,
                  width: 120.w,
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_border),
                      SizedBox(width: 10.w,),
                      Image.asset("assets/images/Messenger_icon.png",width: 20,height: 20,),
                      SizedBox(width: 10.w,),
                      Image.asset("assets/images/add_icon.png",width: 20,height: 20,),
                    ],
                  ),
                )
              ],
            ),
          )
        ],

      ),

    );
  }
}
