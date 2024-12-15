import 'package:flutter/material.dart';
import '../../widgets/direct-screen-widgets/list-view-of-user-widget.dart';
import '../../widgets/direct-screen-widgets/search-field-widget.dart';


class DirectSearchUsersScreen extends StatefulWidget {
  const DirectSearchUsersScreen({super.key});

  @override
  State<DirectSearchUsersScreen> createState() =>
      _DirectSearchUsersScreenState();
}

class _DirectSearchUsersScreenState extends State<DirectSearchUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              children: [
                DirectSearchFieldWidget(

                ),
                SizedBox(
                  height: 5,
                ),
                Divider(),
                Expanded(child: CustomExploreListViewOfUsersWidget())
              ],
            ),
          ),
        ));
  }
}