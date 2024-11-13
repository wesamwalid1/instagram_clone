import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/presentation/screens/home-screens/reels-edit-screen.dart';
import 'package:photo_manager/photo_manager.dart';

class AddReelsScreen extends StatefulWidget {
  const AddReelsScreen({super.key});

  @override
  State<AddReelsScreen> createState() => _AddReelsScreenState();
}

class _AddReelsScreenState extends State<AddReelsScreen> {
  final List<Widget> _mediaList = [];
  final List<File> path = [];
  File? _file;
  int currentPage = 0;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  Future<void> _fetchNewMedia() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: RequestType.video);
      List<AssetEntity> media = await albums[0].getAssetListPaged(page: currentPage, size: 60);
      currentPage++;

      for (var asset in media) {
        if (asset.type == AssetType.video) {
          final file = await asset.file;
          if (file != null) {
            path.add(File(file.path));
            _file ??= path[0];
          }
        }
      }

      List<Widget> temp = media.map((asset) {
        return FutureBuilder(
          future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              return Stack(
                children: [
                  Positioned.fill(
                    child: Image.memory(
                      snapshot.data!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (asset.type == AssetType.video)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        color: Colors.black54,
                        padding: EdgeInsets.symmetric(horizontal: 4.w),
                        child: Text(
                          "${asset.videoDuration.inMinutes}:${(asset.videoDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      }).toList();

      setState(() {
        _mediaList.addAll(temp);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _fetchNewMedia();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'New Reels',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: GridView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          itemCount: _mediaList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 250,
            crossAxisSpacing: 3.w,
            mainAxisSpacing: 5.h,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _file = path[index];
                });
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ReelsEditScreen(_file!),
                ));
              },
              child: _mediaList[index],
            );
          },
        ),
      ),
    );
  }
}
