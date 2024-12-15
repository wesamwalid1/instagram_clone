import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/auth-model.dart';
import '../../../logic/auth-cubit/auth_cubit.dart';


class UsersCustomButtons extends StatefulWidget {
  final UserModel user;
  const UsersCustomButtons({super.key, required this.user});

  @override
  State<UsersCustomButtons> createState() => _UsersCustomButtonsState();
}

class _UsersCustomButtonsState extends State<UsersCustomButtons> {
  Color _followButtonColor = const Color.fromRGBO(31, 161, 255, 1);
  Color _followTextColor = Colors.white;
  String _followButtonText = "Follow";

  @override
  void initState() {
    super.initState();
    _checkFollowingStatus();
  }

  void _checkFollowingStatus() {
    final currentUserUid = BlocProvider.of<AuthCubit>(context).currentUser?.uid;
    if (currentUserUid != null) {
      final isFollowing = widget.user.followers?.contains(currentUserUid) ?? false;
      setState(() {
        if (isFollowing) {
          _followButtonText = "Following";
          _followButtonColor = const Color.fromRGBO(239, 239, 239, 1);
          _followTextColor = Colors.black;
        } else {
          _followButtonText = "Follow";
          _followButtonColor = const Color.fromRGBO(31, 161, 255, 1);
          _followTextColor = Colors.white;
        }
      });
    }
  }

  void _toggleFollowButton() {
    final currentUserUid = BlocProvider.of<AuthCubit>(context).currentUser?.uid;
    if (currentUserUid != null) {
      // Call follow/unfollow action in the cubit
      BlocProvider.of<AuthCubit>(context).followUser(widget.user);

      // Toggle follow button state
      setState(() {
        if (_followButtonText == "Follow") {
          _followButtonText = "Following";
          _followButtonColor = const Color.fromRGBO(239, 239, 239, 1);
          _followTextColor = Colors.black;
        } else {
          _followButtonText = "Follow";
          _followButtonColor = const Color.fromRGBO(31, 161, 255, 1);
          _followTextColor = Colors.white;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _toggleFollowButton,
          child: Container(
            height: 30.h,
            width: 366.w,
            color: _followButtonColor,
            child: Center(
              child: Text(
                _followButtonText,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: _followTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 30.h,
              width: 95.w,
              color: const Color.fromRGBO(239, 239, 239, 1),
              child: Center(
                child: Text(
                  "Message",
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: 30.h,
              width: 95.w,
              color: const Color.fromRGBO(239, 239, 239, 1),
              child: Center(
                child: Text(
                  "Subscribe",
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: 30.h,
              width: 95.w,
              color: const Color.fromRGBO(239, 239, 239, 1),
              child: Center(
                child: Text(
                  "Contact",
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: 30.h,
              width: 32.w,
              color: const Color.fromRGBO(239, 239, 239, 1),
              child: Image.asset(
                "assets/images/add-people-icon.png",
              ),
            ),
          ],
        ),
      ],
    );
  }
}
