import 'package:flutter/material.dart';
import 'package:instagramclone/posts.dart';

class test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
        centerTitle: true,
      ),
      body: Column(
        children: [
           Row(
            children: [
              Text("data"),
              SizedBox(width: 20,),
              Text("data"),
              SizedBox(width: 20,),
            ],
          ),
          SizedBox(height: 50,),

          Expanded(
            child: ListView.builder(
                itemCount: 8,
                itemBuilder: (context, index) {
                  //return post();
                }),
          ),

        ],
      ),
    );
  }
}
