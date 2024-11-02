import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomStoriesListView extends StatefulWidget {
  const CustomStoriesListView({super.key});

  @override
  State<CustomStoriesListView> createState() => _CustomStoriesListViewState();
}

class _CustomStoriesListViewState extends State<CustomStoriesListView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 105.h,
      width: 390.w,
      child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(children: [
              Container(
                height: 72.h,
                width: 72.w,
                //padding: const EdgeInsets.symmetric(horizontal: 15),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/images/post.jpeg',
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(height: 5.h,),
              const Text(
                "Wesam.Walid1",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
              )
            ]);
          }),
    );
  }
}