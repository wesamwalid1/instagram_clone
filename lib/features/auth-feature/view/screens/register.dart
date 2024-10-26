import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/features/auth-feature/view-model/logic/auth-cubit/auth_cubit.dart';

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
    return BlocConsumer<AuthCubit, AuthState>(
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();

          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: const Text("Sign Up", style: TextStyle(fontSize: 25),),
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),
              body: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 35),
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
                          onPressed: () async {
                            String usernameInput = username.text.trim();
                            String emailInput = email.text.trim();
                            String passwordInput = pass.text.trim();
                            String cPasswordInput = cPass.text.trim();
                            if (usernameInput.isNotEmpty &&
                                emailInput.isNotEmpty &&
                                passwordInput.isNotEmpty &&
                                cPasswordInput.isNotEmpty) {
                              if (passwordInput == cPasswordInput) {

                                 cubit.register(
                                    usernameInput, emailInput, passwordInput);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text(
                                      "Password does not match")),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text(
                                    "Please fill in all fields")),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: const Color.fromRGBO(
                                0, 163, 255, 1),
                            minimumSize: Size(400.w, 45.h),
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "login");
                            },
                            child: const Text(
                              "Login.",
                              style: TextStyle(color: Color.fromRGBO(
                                  32, 32, 32, 1),
                              ),
                            ),
                          )
                        ],
                      ),
                    ]
                ),
              ));
        }, listener: (context, state) {
      if (state is AuthSuccess ) {
        Navigator.pushReplacementNamed(context, "login");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("done")),);
      }else if (state is AuthFailure){
        ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text('error')),
        );

      }
    });
  }
}



