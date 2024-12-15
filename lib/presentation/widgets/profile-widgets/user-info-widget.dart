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
