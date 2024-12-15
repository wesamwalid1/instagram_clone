import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/presentation/screens/home-screens/add-post-screen.dart';
import 'package:instagramclone/presentation/screens/home-screens/add-story-screen.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  late PageController pageController;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChange(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              controller: pageController,
              onPageChanged: onPageChange,
              children: [
                //const AddPostScreen(),
                //AddReelsScreen(),
               AddPostScreen(),
                AddStoryScreen(),
              ],
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: 10.h,
              right: _currentIndex == 0 ? 100.w : 150.w,
              child: Container(
                width: 200.w,
                height: 30.h,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20.r)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: (){
                        navigationTapped(0);
                      },
                      child: Text(
                        "Post",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color:
                                _currentIndex == 0 ? Colors.white : Colors.grey),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        navigationTapped(2);
                      },
                      child: Text(
                        "Story",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color:
                            _currentIndex == 1 ? Colors.white : Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
