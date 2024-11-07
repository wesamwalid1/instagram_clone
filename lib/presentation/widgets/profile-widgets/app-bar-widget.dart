import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/auth-cubit/auth_cubit.dart';



class CustomAppBarProfilePage extends StatefulWidget {
  const CustomAppBarProfilePage({super.key});

  @override
  State<CustomAppBarProfilePage> createState() => _CustomAppBarProfilePageState();
}

class _CustomAppBarProfilePageState extends State<CustomAppBarProfilePage> {

  @override
  void initState(){
    super.initState();
    context.read<AuthCubit>().fetchUserInfo();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        String username="" ;

        if (state is AuthSuccess) {
          // Check if the userModel is not null and assign the username
          username = state.userModel!.username ?? "Unknown";
        }

        return Row(
          children: [
            Text(
              username,
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Image.asset(
              "assets/images/add_icon.png",
              width: 24.w,
              height: 24.h,
            ),
            SizedBox(width: 10.w),
            const Icon(
              Icons.menu,
              size: 30,
            ),
          ],
        );
      },
      listener: (context, state) {
        if (state is AuthFailure) {
          // Handle error if needed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
    );
  }
}
