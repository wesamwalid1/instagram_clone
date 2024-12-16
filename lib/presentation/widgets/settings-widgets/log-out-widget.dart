import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/logic/auth-cubit/auth_cubit.dart';
import 'package:instagramclone/generated/l10n.dart'; // Import the generated localization class

class LogOut extends StatefulWidget {
  const LogOut({super.key});

  @override
  State<LogOut> createState() => _LogOutState();
}

class _LogOutState extends State<LogOut> {
  @override
  Widget build(BuildContext context) {
    // Check the current theme mode (light or dark)
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Set colors based on the theme
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final buttonColor = isDarkMode ? Colors.redAccent : Colors.red;

    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _showLogoutConfirmationDialog(context),
          child: Text(
            S.of(context).LogOut, // Localized string for "Log out"
            style: TextStyle(
              color: buttonColor, // Use the theme-based color
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is SignOut) {
          Navigator.pushReplacementNamed(context, "login");
        }
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    // Get the current theme mode
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Set colors based on the theme mode
    final dialogBackgroundColor = isDarkMode ? Colors.black87 : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final buttonColor = isDarkMode ? Colors.redAccent : Colors.red;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: dialogBackgroundColor, // Set dialog background color
          title: Center(
            child: Text(
              S.of(context).LogOut, // Localized string for "Log out"
              style: TextStyle(color: textColor), // Set title color
            ),
          ),
          content: Text(
            S.of(context).LogOutConfirmationMessage, // Localized string for confirmation message
            style: TextStyle(color: textColor), // Set content color
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                S.of(context).No, // Localized string for "No"
                style: TextStyle(color: textColor), // Button color
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthCubit>().signOut(); // Call logout method
              },
              child: Text(
                S.of(context).Yes, // Localized string for "Yes"
                style: TextStyle(color: buttonColor), // Button color
              ),
            ),
          ],
        );
      },
    );
  }
}
