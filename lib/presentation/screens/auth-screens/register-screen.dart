import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/logic/auth-cubit/auth_cubit.dart';
import '../../widgets/auth-widgets/custom_text_form.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController cPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;

          // Define colors based on theme
          final backgroundColor = isDarkMode ? Colors.black : Colors.white;
          final textColor = isDarkMode ? Colors.white : Colors.black;
          final appBarColor = isDarkMode ? Colors.black : Colors.white;
          final buttonColor = isDarkMode ? Colors.blue[700] : Colors.blue[400];

          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(
              backgroundColor: appBarColor,
              title: Text("Sign Up", style: TextStyle(fontSize: 25, color: textColor)),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 35),
                child: Column(
                  children: [
                    CustomTextForm(
                      hint: "Enter your Username",
                      controller: username,
                    ),
                    SizedBox(height: 15.h),
                    CustomTextForm(
                      hint: "Enter your email",
                      controller: email,
                    ),
                    SizedBox(height: 15.h),
                    CustomTextForm(
                      hint: "Enter your password",
                      controller: pass,
                      obscureText: true,
                    ),
                    SizedBox(height: 15.h),
                    CustomTextForm(
                      hint: "Confirm password",
                      controller: cPass,
                      obscureText: true,
                    ),
                    SizedBox(height: 30.h),
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
                              cubit.register(usernameInput, emailInput, passwordInput);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Password does not match")),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Please fill in all fields")),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: buttonColor,
                          minimumSize: Size(400.w, 45.h),
                        ),
                        child: Text(
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
                          child: Text(
                            "Login.",
                            style: TextStyle(color: textColor),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }, listener: (context, state) {
      if (state is AuthSuccess) {
        Navigator.pushReplacementNamed(context, "login");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("done")),
        );
      } else if (state is AuthFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('error')),
        );
      }
    });
  }
}
