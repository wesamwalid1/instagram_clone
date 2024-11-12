import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/logic/auth-cubit/auth_cubit.dart';

class LogOut extends StatefulWidget {
  const LogOut({super.key});

  @override
  State<LogOut> createState() => _LogOutState();
}

class _LogOutState extends State<LogOut> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _showLogoutConfirmationDialog(context),
          child: Text(
            "Log out",
            style: TextStyle(
              color: Colors.red,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }, listener: (context, state) {
      if (state is SignOut) {
        Navigator.pushReplacementNamed(context, "login");
      }
    },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text("Log out")),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("No",style: TextStyle(color: Colors.black),),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthCubit>().signOut(); // Call logout method
              },
              child: const Text("Yes",style: TextStyle(color: Colors.red),),
            ),
          ],
        );
      },
    );
  }
}


