import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_text_form.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final TextEditingController email = TextEditingController();

  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 140,left: 15,right: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 68.h,
                width: 244.w,
                child: Image.asset("assets/images/instagram text logo.png"),
              ),
              SizedBox(height: 25.h),
              //username section
              SizedBox(
                height: 56.h,
                width: 400.w,
                child: CustomTextForm(
                  hint: "Email",
                  controller: email,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              //password section
              SizedBox(
                height: 56.h,
                width: 400.w,
                child: CustomTextForm(
                  hint: "Password",
                  controller: pass,
                  obscureText: true,
                ),
              ),
               SizedBox(height: 100.h,),

              //login button section
              SizedBox(
                height: 106.h,
                width: 400.w,
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: const Color.fromRGBO(0, 163, 255, 1 ),
                          minimumSize: Size(400.w,45.h),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Do not have an email?"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "register");
                          },
                          child: const Text(
                            "Register.",
                            style: TextStyle(color: Color.fromRGBO(32, 32, 32, 1),
                          ),
                          ),
                        )
                      ],
                    )
                  ]
                  ,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
