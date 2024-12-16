import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/auth-cubit/auth_cubit.dart';

class UserProfileData extends StatefulWidget {
  const UserProfileData({super.key});

  @override
  State<UserProfileData> createState() => _UserProfileDataState();
}

class _UserProfileDataState extends State<UserProfileData> {
  @override
  void initState() {
    super.initState();
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    context.read<AuthCubit>().fetchUserInfo(uid);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error,
                style: TextStyle(color: theme.colorScheme.onError),
              ),
              backgroundColor: theme.colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        String profilePhotoUrl = 'assets/images/default_profile.png';
        int postsCount = 0;
        int followersCount = 0;
        int followingCount = 0;

        if (state is AuthSuccess && state.userModel != null) {
          profilePhotoUrl = state.userModel!.profilePhoto?.isNotEmpty == true
              ? state.userModel!.profilePhoto!
              : profilePhotoUrl;
          postsCount = state.userModel!.postsCount ?? 0;
          followersCount = state.userModel!.followersCount ?? 0;
          followingCount = state.userModel!.followingCount ?? 0;
        }

        return Row(
          children: [
            // Profile Image
            Container(
              clipBehavior: Clip.antiAlias,
              height: 75.79.h,
              width: 75.79.w,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: profilePhotoUrl.startsWith('http')
                  ? Image.network(
                profilePhotoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/default_profile.png',
                    fit: BoxFit.cover,
                  );
                },
              )
                  : Image.asset(
                profilePhotoUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 50.w),

            // Posts
            Column(
              children: [
                Text(
                  "$postsCount",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  "Posts",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
            SizedBox(width: 15.w),

            // Followers
            Column(
              children: [
                Text(
                  "$followersCount",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  "Followers",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
            SizedBox(width: 15.w),

            // Following
            Column(
              children: [
                Text(
                  "$followingCount",
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                Text(
                  "Following",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
