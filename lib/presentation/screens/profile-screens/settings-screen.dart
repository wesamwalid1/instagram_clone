import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/presentation/screens/profile-screens/language-screen.dart';
import 'package:instagramclone/presentation/screens/profile-screens/saved-screen.dart';
import 'package:instagramclone/presentation/screens/profile-screens/theme-screen.dart';
import 'package:instagramclone/presentation/widgets/settings-widgets/log-out-widget.dart';
import '../../widgets/settings-widgets/custom-container-widget.dart';
import 'package:instagramclone/generated/l10n.dart'; // Import the generated localization class

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        title: Text(
          S.of(context).Settings, // Localized string for "Settings"
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge!.color,
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 20.sp,
            color: theme.iconTheme.color,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).How_you_use_Instagram, // Localized string for "How you use Instagram"
                style: TextStyle(
                  color: theme.textTheme.bodySmall!.color,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SavedScreen()),
                  );
                },
                child: CustomContainer(
                  imageIcon: "assets/images/bookmark.png",
                  title: S.of(context).Saved, // Localized string for "Saved"
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                S.of(context).Your_app_and_media, // Localized string for "Your app and media"
                style: TextStyle(
                  color: theme.textTheme.bodySmall!.color,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LanguageScreen()),
                  );
                },
                child: CustomContainer(
                  imageIcon: "assets/images/language-icon.png",
                  title: S.of(context).Language, // Localized string for "Language"
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                S.of(context).Theme, // Localized string for "Theme"
                style: TextStyle(
                  color: theme.textTheme.bodySmall!.color,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ThemScreen()),
                  );
                },
                child: CustomContainer(
                  imageIcon: "assets/images/theme.png",
                  title: S.of(context).Theme, // Localized string for "Theme"
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                S.of(context).Login, // Localized string for "Login"
                style: TextStyle(
                  color: theme.textTheme.bodySmall!.color,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                S.of(context).Add_account, // Localized string for "Add account"
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.h),
              const LogOut(),
            ],
          ),
        ),
      ),
    );
  }
}
