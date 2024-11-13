import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ReelsEditScreen extends StatefulWidget {
  final File videoFile;

  const ReelsEditScreen(this.videoFile, {super.key});

  @override
  State<ReelsEditScreen> createState() => _ReelsEditScreenState();
}

class _ReelsEditScreenState extends State<ReelsEditScreen> {
  final TextEditingController descriptionController = TextEditingController();
  late VideoPlayerController videoController;
  ChewieController? chewieController;
  bool isInitialized = false;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (await widget.videoFile.exists()) {
      print("Video file path: ${widget.videoFile.path}");

      try {
        // Initialize VideoPlayerController
        videoController = VideoPlayerController.file(widget.videoFile);

        await videoController.initialize();

        // Initialize Chewie controller
        chewieController = ChewieController(
          videoPlayerController: videoController,
          autoPlay: true,
          looping: true,
        );

        if (mounted) {
          setState(() {
            isInitialized = true;
            isLoading = false;
          });
        }
      } catch (error) {
        // Catch and log specific errors from video player initialization
        print("Error initializing video: $error");
        setState(() {
          errorMessage = "Failed to load video: $error";
          isLoading = false;
        });
      }
    } else {
      // If file doesn't exist, set an appropriate error message
      print("File does not exist at the specified path.");
      setState(() {
        errorMessage = "File does not exist at the specified path.";
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    chewieController?.dispose();
    videoController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Reels',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Container(
                  width: 270.w,
                  height: 420.h,
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : isInitialized
                      ? Chewie(controller: chewieController!)
                      : Center(
                    child: Text(
                      errorMessage ?? "Unknown error loading video.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                height: 60.h,
                width: 280.w,
                child: TextField(
                  controller: descriptionController,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    hintText: 'Write a description ...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Add functionality for saving as draft
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 45.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        "Save draft",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Add functionality for sharing the reel
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 45.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        "Share",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
