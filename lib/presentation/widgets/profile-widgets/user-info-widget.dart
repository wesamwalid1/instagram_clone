import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/auth-cubit/auth_cubit.dart';

class UsersInfo extends StatefulWidget {
  const UsersInfo({super.key});

  @override
  State<UsersInfo> createState() => _UsersInfoState();
}

class _UsersInfoState extends State<UsersInfo> {
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
        String name = '';
        String bio = '';
        String website = '';

        if (state is AuthSuccess) {
          name = state.userModel?.name ?? '';
          bio = state.userModel?.bio ?? '';
          website = state.userModel?.website ?? '';
        }

        return SizedBox(
          width: 300.w,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              if (name.isNotEmpty)
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
              SizedBox(height: name.isNotEmpty ? 4.h : 0),

              // Bio
              if (bio.isNotEmpty)
                Text(
                  bio,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              SizedBox(height: bio.isNotEmpty ? 4.h : 0),

              // Website
              if (website.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    // Optional: Add functionality to open the website in a browser
                  },
                  child: Text(
                    website,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: theme.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
