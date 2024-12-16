import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/auth-cubit/auth_cubit.dart';

class CustomAppBarProfilePage extends StatefulWidget {
  const CustomAppBarProfilePage({super.key});

  @override
  State<CustomAppBarProfilePage> createState() =>
      _CustomAppBarProfilePageState();
}

class _CustomAppBarProfilePageState extends State<CustomAppBarProfilePage> {
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
        String username = "Loading...";

        if (state is AuthSuccess) {
          username = state.userModel?.username ?? "Unknown";
        } else if (state is AuthFailure) {
          username = "Error";
        }

        return Row(
          children: [
            Text(
              username,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "add");
              },
              child: Image.asset(
                "assets/images/add_icon.png",
                width: 24.w,
                height: 24.h,
                color: theme.iconTheme.color, // Adapt to the theme
              ),
            ),
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "settings");
              },
              child: Icon(
                Icons.menu,
                size: 30,
                color: theme.iconTheme.color, // Adapt to the theme
              ),
            ),
          ],
        );
      },
    );
  }
}
