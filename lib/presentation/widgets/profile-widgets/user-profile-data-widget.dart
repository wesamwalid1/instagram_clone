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
    return BlocConsumer<AuthCubit, AuthState>(
        builder: (context, state) {
          String profilePhotoUrl = 'assets/images/default_profile.png';
          int postsCount = 0;
          int followersCount = 0;
          int followingCount = 0;
          // Check if we have a successful state with user info
          if (state is AuthSuccess && state.userModel != null) {
            profilePhotoUrl = (state.userModel!.profilePhoto!.isNotEmpty
                ? state.userModel!.profilePhoto
                : profilePhotoUrl)!;
            postsCount = state.userModel!.postsCount!;
            followersCount = (state.userModel!.followersCount ?? 0);
            followingCount = (state.userModel!.followingCount ?? 0);

          }
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
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "posts",
                    style: TextStyle(fontSize: 12.sp),
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
                    ),
                  ),
                  Text(
                    "Followers",
                    style: TextStyle(fontSize: 12.sp),
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
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Following",
                    style: TextStyle(fontSize: 12.sp),
                  )
                ],
              ),
            ],
          );
        },
        listener: (context, state) {});
  }
}
