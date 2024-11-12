import 'package:flutter/material.dart';
import 'package:instagramclone/core/theme/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    fontFamily: 'SFUIDisplay',
    primaryColor: Colors.black,
    scaffoldBackgroundColor: AppColors.lightBackground,
    brightness: Brightness.light,

  );


  static final DarkTheme = ThemeData(
    fontFamily: 'SFUIDisplay',
    primaryColor: Colors.white,
    scaffoldBackgroundColor: AppColors.darkBackground,
    brightness: Brightness.dark,

  );
}