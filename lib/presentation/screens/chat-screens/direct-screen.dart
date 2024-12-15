import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../widgets/direct-screen-widgets/app-bar-widget.dart';
import '../../widgets/direct-screen-widgets/list-view-users-widget.dart';
import '../../widgets/direct-screen-widgets/search-widget.dart';

class DirectScreen extends StatefulWidget {
  @override
  State<DirectScreen> createState() => _DirectScreenState();
}

class _DirectScreenState extends State<DirectScreen> {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: DirectAppBarWidget(),
              ),
              SizedBox(height: 10.h,),
              CustomSearchBar(onTap: () {
                Navigator.pushNamed(context, 'searchUserScreen');
              },),
              Expanded(
                child: Container(
                    child: ListOfUsersWidget()),
              )
            ],
          ),
        )

    );
  }
}