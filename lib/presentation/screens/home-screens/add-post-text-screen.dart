import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/logic/auth-cubit/auth_cubit.dart';
import 'package:instagramclone/logic/post-cubit/post_cubit.dart';


class AddPostTextScreen extends StatefulWidget {
  File _file;

  AddPostTextScreen(this._file, {super.key});

  @override
  State<AddPostTextScreen> createState() => _AddPostTextScreenState();
}

class _AddPostTextScreenState extends State<AddPostTextScreen> {
  final description = TextEditingController();
  final location = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<PostCubit,PostState>(
        builder: (context,state){
          final postCubit = context.read<PostCubit>();
           final uid = FirebaseAuth.instance.currentUser!.uid ;
          final FirebaseFirestore _firestore = FirebaseFirestore.instance;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
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
                        onTap: ()async{
                          // Fetch the user's username
                          DocumentSnapshot userSnapshot =
                          await _firestore.collection('users').doc(uid).get();
                          String? username = userSnapshot['username'];
                          String? userImage = userSnapshot['profilePhoto'];
                          postCubit.uploadPost(
                            uid: uid,
                            imageFile: widget._file,
                            description: description.text,
                            location: location.text,
                            username: username!,
                            userImage: userImage!
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
            body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                        child: Row(
                          children: [
                            Container(
                              width: 65.w,
                              height: 65.h,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(widget._file), fit: BoxFit.cover,)),
                            ),
                            SizedBox(width: 20.w,),
                            SizedBox(
                              width: 200.w,
                              height: 60.h,
                              child: TextField(
                                controller: description,
                                decoration: const InputDecoration(
                                  hintText:"Write a caption ...",
                                  border: InputBorder.none,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(),
                      SizedBox(height: 10.h,),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 15.w),
                        child: SizedBox(
                          width: 200.w,
                          height: 30.h,
                          child: TextField(
                            controller: location,
                            decoration: const InputDecoration(
                              hintText:"Add location",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          );


    }, listener: (context,state){
      if (state is PostUploadSuccess) {
        // Show success message or navigate
        print('Post uploaded successfully with image: ${state.downloadUrl}');
        Navigator.pushNamed(context, "main_screen");
      } else if (state is PostUploadFailure) {
        // Show error message
        print('Failed to upload post: ${state.error}');
      }
    });

  }
}

