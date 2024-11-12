import 'package:flutter/material.dart';

class UsersTabBar extends StatefulWidget {
  const UsersTabBar({super.key});

  @override
  State<UsersTabBar> createState() => _UsersTabBarState();
}

class _UsersTabBarState extends State<UsersTabBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            bottom: TabBar(indicatorColor:Colors.black87,tabs: [
              Tab(
                icon: Image.asset("assets/images/parent_components.png"),
              ),
              Tab(
                icon: Image.asset("assets/images/reels-icon.png"),
              ),
              Tab(
                icon: Image.asset("assets/images/mentions.png"),
              ),
            ]),
          ),
          body: const TabBarView(children: [
            Center(
              child: Text("Tab 1"),
            ),
            Center(
              child: Text("Tab 2"),
            ),
            Center(
              child: Text("Tab 3"),
            )
          ]),
        ));
  }
}
