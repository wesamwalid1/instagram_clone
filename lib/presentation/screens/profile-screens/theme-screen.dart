import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramclone/generated/l10n.dart'; // Import the generated localization class
import '../../../logic/theme-cubit/theme_cubit.dart';

class ThemScreen extends StatefulWidget {
  const ThemScreen({super.key});

  @override
  State<ThemScreen> createState() => _ThemScreenState();
}

class _ThemScreenState extends State<ThemScreen> {
  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final theme = Theme.of(context);

    // Determine the current theme for proper color handling
    final isDarkMode = themeCubit.isDarkTheme;
    final appBarColor = isDarkMode ? Colors.black : Colors.white;
    final titleColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor, // Set the app bar color based on the theme
        title: Text(
          S.of(context).Theme, // Localized string for "Theme"
          style: TextStyle(color: titleColor), // Title color based on theme
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListTile(
          title: Text(S.of(context).DarkMode), // Localized string for "Dark Mode"
          trailing: Switch(
            value: themeCubit.isDarkTheme,
            onChanged: (value) {
              themeCubit.toggleTheme(value); // Toggle the theme using the cubit
            },
          ),
        ),
      ),
    );
  }
}
