import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramclone/logic/post-cubit/post_cubit.dart';
import 'package:video_player/video_player.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<XFile> _pickedMedia = [];
  VideoPlayerController? _videoController;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickMedia(bool isImage) async {
    if (isImage) {
      final List<XFile>? images = await _picker.pickMultiImage();
      setState(() {
        _pickedMedia = images ?? [];
        _videoController?.dispose();
        _videoController = null;
      });
    } else {
      final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
      if (video != null) {
        _videoController = VideoPlayerController.file(File(video.path))
          ..initialize().then((_) {
            setState(() {
              _pickedMedia = [video];
              _videoController!.setLooping(true);
              _videoController!.play();
            });
          }).catchError((e) {
            print("Error initializing video: $e");
          });
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostCubit, PostState>(listener: (context, state) {

       if (state is PostUploadSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Post shared successfully!")),
        );
        Navigator.pop(context);
      } else if (state is PostUploadFailure) {
        print("Failed to share post: ${state.error}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to share post: ${state.error}")),
        );
      }
    }, builder: (context, state) {
      if (state is PostLoading){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      final postCubit = context.read<PostCubit>();
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "New post",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: false,
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Center(
                  child: GestureDetector(
                    onTap: () async {
                      // Fetch the user's username
                      DocumentSnapshot userSnapshot =
                      await _firestore.collection('users').doc(uid).get();
                      String? username = userSnapshot['username'];
                      String? userImage = userSnapshot['profilePhoto'];

                      postCubit.uploadPost(
                        uid: uid,
                        mediaFiles:
                        _pickedMedia.map((file) => File(file.path)).toList(),
                        description: _descriptionController.text,
                        username: username!,
                        userImage: userImage!,
                        mediaType: _videoController != null
                            ? "video"
                            : _pickedMedia.length > 1
                            ? "carousel"
                            : "image",
                        location: 'ggg',
                      );
                    },
                    child: Text(
                      "Share",
                      style: TextStyle(color: Colors.blue, fontSize: 15.sp),
                    ),
                  )),
            ),
          ],
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => _pickMedia(true),
                  child: const Text('Pick Images'),
                ),
                SizedBox(width: 10.w),
                ElevatedButton(
                  onPressed: () => _pickMedia(false),
                  child: const Text('Pick Video'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Enter a description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ),
            Expanded(
              child: _pickedMedia.isEmpty
                  ? const Center(child: Text('No media selected'))
                  : GridView.builder(
                itemCount: _pickedMedia.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _videoController != null ? 1 : 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemBuilder: (context, index) {
                  if (_videoController != null && index == 0) {
                    return AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    );
                  } else {
                    return Image.file(
                      File(_pickedMedia[index].path),
                      fit: BoxFit.cover,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
