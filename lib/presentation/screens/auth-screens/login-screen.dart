import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/auth-cubit/auth_cubit.dart';
import '../../widgets/auth-widgets/custom_text_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

        // Define colors based on theme
        final backgroundColor = isDarkMode ? Colors.black : Colors.white;
        final textColor = isDarkMode ? Colors.white : Colors.black;
        final buttonColor = isDarkMode ? Colors.blue[700] : Colors.blue[400];

        // Define the logo image based on theme
        final logoImage = isDarkMode
            ? "assets/images/instagram_text_logo_dark.png"  // Use a dark version of the logo
            : "assets/images/instagram_text_logo.png";      // Use the default logo

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 140, left: 15, right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 68.h,
                    width: 244.w,
                    child: Image.asset(logoImage),  // Update the logo image based on the theme
                  ),
                  SizedBox(height: 25.h),
                  // Username section
                  SizedBox(
                    height: 56.h,
                    width: 400.w,
                    child: CustomTextForm(
                      hint: "Email",
                      controller: email,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  // Password section
                  SizedBox(
                    height: 56.h,
                    width: 400.w,
                    child: CustomTextForm(
                      hint: "Password",
                      controller: pass,
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 100.h),
                  // Login button section
                  SizedBox(
                    height: 106.h,
                    width: 400.w,
                    child: Column(
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              String emailInput = email.text.trim();
                              String passwordInput = pass.text.trim();
                              if (emailInput.isNotEmpty && passwordInput.isNotEmpty) {
                                await cubit.login(emailInput, passwordInput);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Please fill in all fields")),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)),
                              backgroundColor: buttonColor,
                              minimumSize: Size(400.w, 45.h),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(color: textColor),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Do not have an email?"),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "register");
                              },
                              child: Text(
                                "Register.",
                                style: TextStyle(color: textColor),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacementNamed(context, "main_screen");
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
    );
  }
}
