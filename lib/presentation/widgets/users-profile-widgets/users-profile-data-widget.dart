import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/auth-model.dart';

class UsersProfileData extends StatelessWidget {
  final UserModel user;

  const UsersProfileData({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    String profilePhotoUrl = 'assets/images/default_profile.png';
    int postsCount = 0;
    int followersCount = 0;
    int followingCount = 0;
    profilePhotoUrl =
    (user.profilePhoto!.isNotEmpty ? user.profilePhoto : profilePhotoUrl)!;
    postsCount = (user.postsCount ?? postsCount);
    followersCount = (user.followersCount ?? followersCount);
    followingCount = (user.followingCount ?? followingCount);

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          height: 75.79.h,
          width: 75.79.w,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: profilePhotoUrl.startsWith('http')
              ? Image.network(
            profilePhotoUrl,
            fit: BoxFit.cover,
          )
              : Image.asset(
            profilePhotoUrl,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: 50.w,
        ),
        Column(
          children: [
            Text(
              "$postsCount",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,  // Text color based on theme
              ),
            ),
            Text(
              "posts",
              style: TextStyle(
                fontSize: 12.sp,
                color: isDarkMode ? Colors.white : Colors.black,  // Text color based on theme
              ),
            )
          ],
        ),
        SizedBox(
          width: 15.w,
        ),
        Column(
          children: [
            Text(
              "$followersCount",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,  // Text color based on theme
              ),
            ),
            Text(
              "Followers",
              style: TextStyle(
                fontSize: 12.sp,
                color: isDarkMode ? Colors.white : Colors.black,  // Text color based on theme
              ),
            )
          ],
        ),
        SizedBox(
          width: 15.w,
        ),
        Column(
          children: [
            Text(
              "$followingCount",
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,  // Text color based on theme
              ),
            ),
            Text(
              "Following",
              style: TextStyle(
                fontSize: 12.sp,
                color: isDarkMode ? Colors.white : Colors.black,  // Text color based on theme
              ),
            )
          ],
        ),
      ],
    );
  }
}
