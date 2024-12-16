import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/language-cubit/language_cubit.dart';
import 'package:instagramclone/generated/l10n.dart';

class LanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<LanguageCubit>().state.languageCode;
    // Get the current theme mode (light or dark)
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Set colors based on theme mode
    final appBarColor = isDarkMode ? Colors.black : Colors.white;
    final titleColor = isDarkMode ? Colors.white : Colors.black;
    final tileColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final selectedIconColor = Colors.green;
    final unselectedIconColor = isDarkMode ? Colors.grey : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          S.of(context).Change_Language, // Localized string for "Change Language"
          style: TextStyle(color: titleColor, fontSize: 15.sp),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildLanguageOption(
            context,
            title: S.of(context).English, // Localized string for "English"
            languageCode: 'en',
            isSelected: currentLocale == 'en',
            tileColor: tileColor ?? Colors.white, // Provide fallback color
            selectedIconColor: selectedIconColor,
            unselectedIconColor: unselectedIconColor,
          ),
          _buildLanguageOption(
            context,
            title: S.of(context).Arabic, // Localized string for "Arabic"
            languageCode: 'ar',
            isSelected: currentLocale == 'ar',
            tileColor: tileColor ?? Colors.white, // Provide fallback color
            selectedIconColor: selectedIconColor,
            unselectedIconColor: unselectedIconColor,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, {
        required String title,
        required String languageCode,
        required bool isSelected,
        required Color tileColor,
        required Color selectedIconColor,
        required Color unselectedIconColor,
      }) {
    return ListTile(
      tileColor: tileColor, // Now guaranteed to be non-null
      title: Text(title),
      trailing: isSelected
          ? Icon(Icons.check, color: selectedIconColor)
          : Icon(Icons.check, color: unselectedIconColor),
      onTap: () {
        context.read<LanguageCubit>().changeLanguage(languageCode);
      },
    );
  }
}
