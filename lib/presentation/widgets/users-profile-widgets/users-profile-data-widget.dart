import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../data/models/auth-model.dart';

class UsersProfileData extends StatelessWidget {
  final UserModel user;

  const UsersProfileData({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    String profilePhotoUrl = 'assets/images/default_profile.png';
    profilePhotoUrl = (user.profilePhoto!.isNotEmpty ? user.profilePhoto : profilePhotoUrl)!;

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid) // Assuming 'uid' is the document ID
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading profile data'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Retrieve data
        final userData = snapshot.data?.data() as Map<String, dynamic>?;

        int postsCount = userData?['postsCount'] ?? 0;
        int followersCount = userData?['followersCount'] ?? 0;
        int followingCount = userData?['followingCount'] ?? 0;

        return Row(
          children: [
            // Profile Photo
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
            SizedBox(width: 50.w),

            // Posts Count
            Column(
              children: [
                Text(
                  "$postsCount",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  "Posts",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )
              ],
            ),
            SizedBox(width: 15.w),

            // Followers Count
            Column(
              children: [
                Text(
                  "$followersCount",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  "Followers",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )
              ],
            ),
            SizedBox(width: 15.w),

            // Following Count
            Column(
              children: [
                Text(
                  "$followingCount",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  "Following",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
