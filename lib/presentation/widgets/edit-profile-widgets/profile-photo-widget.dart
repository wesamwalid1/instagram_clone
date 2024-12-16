import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/generated/l10n.dart';
import '../../../logic/auth-cubit/auth_cubit.dart';

class ProfilePhotoWidget extends StatefulWidget {
  const ProfilePhotoWidget({super.key});

  @override
  State<ProfilePhotoWidget> createState() => _ProfilePhotoWidgetState();
}

class _ProfilePhotoWidgetState extends State<ProfilePhotoWidget> {
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();

    return SizedBox(
      height: 150.h,
      width: 390.h,
      child: Column(
        children: [
          Container(
            height: 98.74.h,
            width: 98.8.w,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                String profilePhotoUrl = 'assets/images/default_profile.png';

                if (state is AuthSuccess && state.userModel != null) {
                  profilePhotoUrl = (state.userModel!.profilePhoto!.isNotEmpty
                      ? state.userModel!.profilePhoto
                      : profilePhotoUrl)!;
                }

                return Container(
                  clipBehavior: Clip.antiAlias,
                  height: 75.79.h,
                  width: 75.79.w,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child:profilePhotoUrl.startsWith('http')
                      ? Image.network(
                    profilePhotoUrl,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    profilePhotoUrl,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () async {
              await authCubit.updateProfilePhoto();
            },
            child: Text(
              S.of(context).Change_Profile_photo,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color.fromRGBO(56, 151, 240, 1),
              ),
            ),
          )
        ],
      ),
    );
  }
}