import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      height: 166.31.h,
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
                String photoUrl = "https://static.thenounproject.com/png/5034901-200.png";

                if (state is AuthSuccess && state.userModel != null) {
                  photoUrl = (state.userModel!.profilePhoto!.isNotEmpty
                      ? state.userModel!.profilePhoto
                      : photoUrl)!;
                }

                return Image(
                  image: _imageFile != null
                      ? FileImage(_imageFile!)
                      : NetworkImage(photoUrl) as ImageProvider,
                  fit: BoxFit.cover,
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
              "Change Profile Photo",
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