import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../logic/auth-cubit/auth_cubit.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        String? name;
        String? bio;
        String? website;

        if (state is AuthSuccess) {
          name = state.userModel?.name;
          bio = state.userModel?.bio;
          website = state.userModel?.website;
        }

        return SizedBox(
          width: 300.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (name != null && name.isNotEmpty)
                Text(
                  name,
                  style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold),
                ),
              if (bio != null && bio.isNotEmpty)
                Text(
                  bio,
                  style: TextStyle(fontSize: 10.sp),
                ),
              if (website != null && website.isNotEmpty)
                Text(
                  website,
                  style: TextStyle(fontSize: 10.sp, color: Colors.blue),
                ),
            ],
          ),
        );
      },
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
    );
  }
}
