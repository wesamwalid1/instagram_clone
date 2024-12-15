import 'package:flutter/material.dart';
import '../../../data/models/post-model.dart';
import '../../widgets/datalis-screens-widgets/custom-app-bar-widget.dart';
import '../../widgets/datalis-screens-widgets/datalis-listview-widget.dart';

class DatalisScreen extends StatefulWidget {
  final List<PostModel> posts;
  final int initIndex;
  final String? username;
  final String title;
  const DatalisScreen({super.key, required this.posts, required this.initIndex, this.username, required this.title});

  @override
  State<DatalisScreen> createState() => _DatalisScreenState();
}

class _DatalisScreenState extends State<DatalisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
            children: [
              if(widget.username!=null)
                CustomAppBarWidget(title: widget.title,username: widget.username,)
              else
                CustomAppBarWidget(title: widget.title,),

              Divider(color: Colors.grey.shade200),
              DatalisListviewWidget(posts:widget.posts,initIndex: widget.initIndex,)

            ],


        ),
      ),

    );
  }
}
