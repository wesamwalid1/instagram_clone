import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/presentation/widgets/home-widgets/app-bar-widget.dart';
import 'package:instagramclone/presentation/widgets/home-widgets/stories-list-view-widget.dart';
import '../../../logic/post-cubit/post_cubit.dart';
import '../../../shared/widgets/datalis-screens-widgets/datalis-listview-widget.dart';
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
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
                child: const CustomAppBarHomePage(),
              ),
              SizedBox(
                height: 20.h,
              ),
              const CustomStoriesListView(),
              Divider(),
             // Column(
             //   children: [
             //     // BlocConsumer<PostCubit, PostState>(builder: (context, state) {
             //     //   if (state is PostLoading) {
             //     //     return const Center(child: CircularProgressIndicator());
             //     //   } else if (state is PostLoadSuccess) {
             //     //     final posts = state.posts;
             //     //
             //     //     if (posts.isEmpty) {
             //     //       return Center(
             //     //         child: Text(
             //     //           "No posts yet",
             //     //           style: TextStyle(fontSize: 18.sp, color: Colors.grey),
             //     //         ),
             //     //       );
             //     //     }
             //     //     return SizedBox(
             //     //       child: DatalisListviewWidget(
             //     //         posts: posts,
             //     //         // initIndex: 0,
             //     //       ),
             //     //     );
             //     //   } else if (state is PostLoadFailure) {
             //     //     return const Center(
             //     //       child: Text("Failed to load posts"),
             //     //     );
             //     //   } else {
             //     //     return const SizedBox();
             //     //   }
             //     // }, listener: (context, state) {
             //     //   if (state is PostLoadFailure) {
             //     //     ScaffoldMessenger.of(context).showSnackBar(
             //     //       SnackBar(content: Text(state.error)),
             //     //     );
             //     //   }
             //     // })
             //   ],
             // )

              CustomPostsListview()
            ],
          ),
        ));
  }
}
