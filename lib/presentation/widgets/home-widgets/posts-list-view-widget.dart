import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

import '../../../data/models/post-model.dart';
import '../../../logic/post-cubit/post_cubit.dart';

class CustomPostsListview extends StatefulWidget {
  const CustomPostsListview({super.key});

  @override
  State<CustomPostsListview> createState() => _CustomPostsListviewState();
}

class _CustomPostsListviewState extends State<CustomPostsListview> {
  late ItemScrollController itemScrollController;
  late ItemPositionsListener itemPositionsListener;
  int _visibleIndex = 0;
  final Map<int, PageController> _pageControllers = {};

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    context.read<PostCubit>().loadFollowedUserPosts(uid);

    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();

    // Add listener to track visible indices
    itemPositionsListener.itemPositions.addListener(() {
      final visibleItems = itemPositionsListener.itemPositions.value
          .where((position) => position.itemTrailingEdge > 0 && position.itemLeadingEdge < 1)
          .map((position) => position.index)
          .toList();

      if (visibleItems.isNotEmpty && _visibleIndex != visibleItems.first) {
        setState(() {
          _visibleIndex = visibleItems.first;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(
      builder: (context, state) {
        final uid = FirebaseAuth.instance.currentUser!.uid;
        final cubit = context.read<PostCubit>();

        if (state is PostLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is PostLoadSuccess) {
          final posts = state.posts;

          if (posts.isEmpty) {
            return Center(child: Text("No posts available"));
          }

          return ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              _pageControllers[index] ??= PageController();

              return Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 15.w,
                            backgroundImage: post.userImage!.isNotEmpty
                                ? NetworkImage(post.userImage!)
                                : null,
                            child: post.userImage!.isEmpty
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.username!.toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                  color: Theme.of(context).brightness == Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                              Text(
                                post.location!,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Theme.of(context).brightness == Brightness.light
                                      ? Colors.black
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Icon(
                            Icons.more_horiz,
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.black
                                : Colors.white,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.h),
                    GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          context.read<PostCubit>().toggleLikePost(post, uid);
                        });
                      },
                      child: post.mediaType! == 'video'
                          ? VideoPlayerWidget(
                        url: post.mediaUrls!.first,
                        isVisible: _visibleIndex == index,
                      )
                          : post.mediaType! == 'carousel'
                          ? SizedBox(
                        height: 390.h, // Adjust height as needed
                        child: PageView.builder(
                          controller: _pageControllers[index],
                          itemCount: post.mediaUrls!.length,
                          itemBuilder: (context, carouselIndex) {
                            return Image.network(
                              post.mediaUrls![carouselIndex],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      )
                          : Image.network(
                        post.mediaUrls!.first,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    if (post.mediaUrls!.length > 1)
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            post.mediaUrls!.length,
                                (dotIndex) => AnimatedBuilder(
                              animation: _pageControllers[index]!,
                              builder: (context, _) {
                                int currentPage = _pageControllers[index]!
                                    .hasClients
                                    ? _pageControllers[index]!.page?.round() ?? 0
                                    : 0;
                                bool isActive = currentPage == dotIndex;
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                                  child: Container(
                                    width: isActive ? 10.w : 6.w,
                                    height: 6.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isActive
                                          ? Colors.blue
                                          : Theme.of(context).brightness == Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    PostActions(
                      post: post,
                      uid: uid,
                      onLikeToggle: () {
                        setState(() {
                          cubit.toggleLikePost(post, uid);
                        });
                      },
                      onFavoriteToggle: () async {
                        await cubit.toggleFavoritePost(post);
                        setState(() {});
                      },
                    ),
                    PostLikesCount(post: post),
                    PostDescription(post: post),
                  ],
                ),
              );
            },
          );
        } else if (state is PostLoadFailure) {
          return Center(child: Text("Failed to load posts: ${state.error}"));
        } else {
          return Center(child: Text("Unexpected state"));
        }
      },
      listener: (context, state) {
        print('Current State: $state'); // Log the state
      },
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final bool isVisible; // Add this parameter

  const VideoPlayerWidget({Key? key, required this.url, required this.isVisible})
      : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {}); // Ensure the first frame is shown after the video is initialized
      });
  }

  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible) {
      _controller.play();
    } else {
      _controller.pause();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: 390.w,
        height: 390.w,
        child: VideoPlayer(_controller),
      ),
    )
        : Container(
      height: 390.h,
      width: 390.w,
      color: Colors.black,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class PostActions extends StatefulWidget {
  final PostModel post;
  final String uid;
  final VoidCallback onLikeToggle;
  final VoidCallback onFavoriteToggle;

  const PostActions({
    required this.post,
    required this.uid,
    required this.onLikeToggle,
    required this.onFavoriteToggle,
  });

  @override
  State<PostActions> createState() => _PostActionsState();
}

class _PostActionsState extends State<PostActions> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PostCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          // Like button
          GestureDetector(
            child: Icon(
              (widget.post.likes?.contains(widget.uid) ?? false)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: (widget.post.likes?.contains(widget.uid) ?? false)
                  ? Colors.red
                  : Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              size: 30.w,
            ),
            onTap: widget.onLikeToggle,
          ),
          SizedBox(width: 10.w),
          // Comment and Send icons
          Image.asset(
            "assets/images/comment.png",
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            width: 24.w,
            height: 24.h,
            fit: BoxFit.fill,
          ),
          SizedBox(width: 10.w),
          Image.asset(
            "assets/images/share.png",
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            width: 24.w,
            height: 24.h,
            fit: BoxFit.fill,
          ),
          Spacer(),
          // Save button
          GestureDetector(
            child: Icon(
              widget.post.isSaved ? Icons.bookmark : Icons.bookmark_border,
              color: widget.post.isSaved
                  ? Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white
                  : Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              size: 30.sp,
            ),
            onTap: widget.onFavoriteToggle,
          ),
        ],
      ),
    );
  }
}

class PostLikesCount extends StatelessWidget {
  final PostModel post;

  const PostLikesCount({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          Text(
            '${post.likes?.length ?? 0}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 5.w),
          const Text('Likes', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class PostDescription extends StatelessWidget {
  final PostModel post;

  const PostDescription({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          Text(
            post.username ?? 'Username',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 5.w),
          Expanded(child: Text(post.description ?? '')),
        ],
      ),
    );
  }
}
