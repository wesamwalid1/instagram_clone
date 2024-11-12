import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';

import 'add-post-text-screen.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final List<Widget> _mediaList = [];
  final List<File> path = [];
  File? _file;
  int currentPage = 0;
  int? lastPage;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  _fetchNewMedia() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    lastPage = currentPage;
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> album =
          await PhotoManager.getAssetPathList(onlyAll: true);
      List<AssetEntity> media =
          await album[0].getAssetListPaged(page: currentPage, size: 60);
      for (var asset in media) {
        if (asset.type == AssetType.image) {
          final file = await asset.file;
          if (file != null) {
            path.add(File(file.path));
            _file = path[0];
          }
        }
      }
      List<Widget> temp = [];
      for (var asset in media) {
        temp.add(
          FutureBuilder(
            future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Container(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.memory(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        );
      }
      setState(() {
        _mediaList.addAll(temp);
        currentPage++; // Move to the next page for pagination
        isLoading = false; // Stop loading
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchNewMedia();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchNewMedia(); // Fetch new media when scroll reaches the bottom
      }
    });
  }

  int indexx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Add Post",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddPostTextScreen(_file!)));
              },
              child: Text(
                "Next",
                style: TextStyle(fontSize: 15.sp, color: Colors.blue),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 375.h,
                child: GridView.builder(
                    itemCount: 1,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 1,
                            crossAxisSpacing: 1),
                    itemBuilder: (context, index) {
                      return _mediaList[indexx];
                    }),
              ),
              if (isLoading) const CircularProgressIndicator(),
              Container(
                width: double.infinity,
                height: 40.h,
                color: Colors.white,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "Recent",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
              GridView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: _mediaList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 2),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            indexx = index;
                            _file = path[index];
                          });
                        },
                        child: _mediaList[index]);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
