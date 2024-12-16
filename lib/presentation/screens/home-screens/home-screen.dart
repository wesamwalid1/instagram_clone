import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/presentation/widgets/home-widgets/app-bar-widget.dart';
import 'package:instagramclone/presentation/widgets/home-widgets/stories-list-view-widget.dart';
import '../../../logic/post-cubit/post_cubit.dart';
import '../../widgets/home-widgets/posts-list-view-widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    context.read<PostCubit>().loadFollowedUserPosts(uid);
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme's brightness
    final brightness = Theme.of(context).brightness;

    return Scaffold(
      // Set the background color based on the theme mode
      backgroundColor: brightness == Brightness.dark
          ? Colors.black
          : Colors.white,

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
              child: CustomAppBarHomePage(),
            ),
            SizedBox(
              height: 20.h,
            ),
            const CustomStoriesListView(),
            const Divider(),

            const CustomPostsListview()
          ],
        ),
      ),
    );
  }
}
