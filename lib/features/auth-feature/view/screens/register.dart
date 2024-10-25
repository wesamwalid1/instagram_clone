import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_text_form.dart';


class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController cPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Sign Up",style: TextStyle(fontSize: 25),),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15,right: 15,top: 35),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextForm(
              hint: "Enter your Username",
              controller: username,
            ),
            SizedBox(height: 15.h,),
            CustomTextForm(
              hint: "Enter your email",
              controller: email,
            ),
            SizedBox(height: 15.h,),
            CustomTextForm(
              hint: "Enter your password",
              controller: pass,
              obscureText: true,
            ),
            SizedBox(height: 15.h,),
            CustomTextForm(
              hint: "Confirm password",
              controller: cPass,
              obscureText: true,
            ),
            SizedBox(height: 30.h,),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: const Color.fromRGBO(0, 163, 255, 1 ),
                  minimumSize: Size(400.w,45.h),
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white),
                )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Do you have an email?"),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, "login");
              },
              child: const Text(
                "Login.",
                style: TextStyle(color: Color.fromRGBO(32, 32, 32, 1),
                ),
              ),
            )
          ],
        ),
        ]
      ),
    ));
  }
}
