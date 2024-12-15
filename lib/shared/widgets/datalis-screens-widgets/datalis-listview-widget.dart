import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';
import '../../../data/models/post-model.dart';
import '../../../logic/post-cubit/post_cubit.dart';

class DatalisListviewWidget extends StatefulWidget {
  final List<PostModel> posts;
  final int? initIndex;
  const DatalisListviewWidget({super.key, required this.posts,  this.initIndex});

  @override
  State<DatalisListviewWidget> createState() => _DatalisListviewWidgetState();
}

class _DatalisListviewWidgetState extends State<DatalisListviewWidget> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  late ItemScrollController itemScrollController;
  late ItemPositionsListener itemPositionsListener;
  int _visibleIndex = 0;

  final Map<int, PageController> _pageControllers = {};

  @override
  void initState() {
    super.initState();
    itemScrollController = ItemScrollController();
    itemPositionsListener =
        ItemPositionsListener.create(); // Correctly initialize here

    // Add listener to track visible indices
    itemPositionsListener.itemPositions.addListener(() {
      final visibleItems = itemPositionsListener.itemPositions.value
          .where((position) =>
      position.itemTrailingEdge > 0 && position.itemLeadingEdge < 1)
          .map((position) => position.index)
          .toList();

      if (visibleItems.isNotEmpty && _visibleIndex != visibleItems.first) {
        setState(() {
          _visibleIndex = visibleItems.first;
        });
      }
    });
    if(widget.initIndex!=null){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (itemScrollController.isAttached) {
          itemScrollController.jumpTo(index: widget.initIndex!);
        }
      });
    }



  }
  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ScrollablePositionedList.builder(
            itemCount: widget.posts.length,
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
            // Pass it here
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final post = widget.posts[index];
              String? mediaType = post.mediaType;
              List<String> mediaUrls = List<String>.from(post.mediaUrls ?? []);
              String location = post.location ?? 'Unknown location';
              String username = post.username ?? 'Unknown username';
              String? userImage = post.userImage;
              _pageControllers[index] ??= PageController();

              return Padding(
                padding: EdgeInsets.only(bottom: 30.h),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 15.w,
                            backgroundImage: userImage!.isNotEmpty
                                ? NetworkImage(userImage)
                                : null,
                            child: userImage.isEmpty
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp),
                              ),
                              Text(
                                location,
                                style: TextStyle(fontSize: 11.sp),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.more_horiz),
                        ],
                      ),
                    ),
                    GestureDetector(
                        onDoubleTap: () {
                          setState(() {
                            context.read<PostCubit>().toggleLikePost(post, uid);
                          });
                        },
                        child: mediaType == 'video'
                            ? VideoPlayerWidget(
                          url: mediaUrls.first,
                          isVisible: _visibleIndex == index,
                        )
                            : mediaType == 'carousel'
                            ? SizedBox(
                          height: 390.h, // Adjust height as needed
                          child: PageView.builder(
                            controller: _pageControllers[index],
                            itemCount: mediaUrls.length,
                            itemBuilder: (context, carouselIndex) {
                              return Image.network(
                                mediaUrls[carouselIndex],
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        )
                            : Image.network(
                          mediaUrls.first,
                          fit: BoxFit.cover,
                        )),
                    SizedBox(height: 10.h),
                    if (mediaUrls.length > 1)
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            mediaUrls.length,
                                (dotIndex) => AnimatedBuilder(
                              animation: _pageControllers[index]!,
                              builder: (context, _) {
                                int currentPage = _pageControllers[index]!
                                    .hasClients
                                    ? _pageControllers[index]!.page?.round() ??
                                    0
                                    : 0;
                                bool isActive = currentPage == dotIndex;
                                return Padding(
                                  padding:
                                  EdgeInsets.symmetric(horizontal: 4.w),
                                  child: Container(
                                    width: isActive ? 10.w : 6.w,
                                    height: 6.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                      isActive ? Colors.blue : Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    BlocConsumer<PostCubit, PostState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        final cubit = context.read<PostCubit>();
                        return PostActions(
                          post: post,
                          uid: uid,
                          onLikeToggle: () {
                            setState(() {
                              cubit.toggleLikePost(post, uid);
                            });
                          },
                          onFavoriteToggle: ()  {
                            setState(() {
                              cubit.toggleFavoritePost(post);
                            });
                          },
                        );
                      },
                    ),
                    PostLikesCount(post: post),
                    PostDescription(post: post),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


class VideoPlayerWidget extends StatefulWidget {
  final String url;
  final bool isVisible; // Add this parameter

  const VideoPlayerWidget(
      {Key? key, required this.url, required this.isVisible})
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
        setState(
                () {}); // Ensure the first frame is shown after the video is initialized
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
              onTap: widget.onFavoriteToggle),
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
