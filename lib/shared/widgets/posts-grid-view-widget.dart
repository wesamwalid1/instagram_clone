import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import '../../data/models/post-model.dart';
import '../screens/datalis-screens/datalis-screen.dart';

class PostsGridViewWidget extends StatefulWidget {
  final List<PostModel> posts;
  final String? username;
  final String title;
  const PostsGridViewWidget({super.key, required this.posts, this.username, required this.title});

  @override
  State<PostsGridViewWidget> createState() => _PostsGridViewWidgetState();
}

class _PostsGridViewWidgetState extends State<PostsGridViewWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
      itemCount: widget.posts.length,
      itemBuilder: (context, index) {
        final post = widget.posts[index];
        final mediaUrls = post.mediaUrls;
        final mediaType = post.mediaType;
       // final username = post.username;

        return GestureDetector(
            onTap: () {
              if (widget.username!=null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DatalisScreen(
                      username:widget.username ,
                      title: widget.title,
                      posts: widget.posts,
                      initIndex: index,
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DatalisScreen(
                      title: widget.title,
                      posts: widget.posts,
                      initIndex: index,
                    ),
                  ),
                );
              }
            },
            child: Container(
              child: mediaType == 'video'
                  ? Stack(
                children: [
                  Positioned.fill(
                    child: VideoThumbnailWidget(videoUrl: mediaUrls![0]),
                  ),
                  Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                          width: 15.w,
                          height: 15.h,
                          child: Image.asset(
                            'assets/images/video.png',
                          ))),
                ],
              )
                  : mediaType == 'carousel'
                  ? Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      mediaUrls![0],
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                      const Center(
                          child: Icon(Icons.error,
                              color: Colors.red)),
                    ),
                  ),
                  Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                          width: 15.w,
                          height: 15.h,
                          child: Image.asset(
                            'assets/images/multiple-image.png',
                          ))),
                ],
              )
                  : Image.network(
                mediaUrls![0],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Center(
                    child: Icon(Icons.error,
                        color: Colors.red)),
              ),
            ));
      },
    );
  }
}

class VideoThumbnailWidget extends StatefulWidget {
  final String videoUrl;

  const VideoThumbnailWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoThumbnailWidgetState createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Update the UI when video is loaded
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : const Center(child: CircularProgressIndicator());
  }
}