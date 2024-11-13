import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../logic/post-cubit/post_cubit.dart';
import '../../screens/explore-screens/details-screen.dart';

class ExplorePostsGridViewWidget extends StatefulWidget {
  const ExplorePostsGridViewWidget({super.key});

  @override
  State<ExplorePostsGridViewWidget> createState() => _ExplorePostsGridViewWidgetState();
}

class _ExplorePostsGridViewWidgetState extends State<ExplorePostsGridViewWidget> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    // Load posts using cubit when screen is initialized
    context.read<PostCubit>().loadPosts(currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, PostState>(
      builder: (context, state) {
        if (state is PostLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PostLoadSuccess) {
          final posts = state.posts;

          if (posts.isEmpty) {
            return const Center(child: Text("No posts available"));
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              childAspectRatio: 1,
            ),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              var post = posts[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to DetailsScreen with the selected post at the top
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        posts: posts,
                        selectedPost: post, // Pass the tapped post as selectedPost
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(post['postImage']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is PostLoadFailure) {
          return Center(child: Text("Error loading posts: ${state.error}"));
        } else {
          return Container(); // Fallback in case of unexpected state
        }
      },
    );
  }
}
