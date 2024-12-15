import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/auth-cubit/auth_cubit.dart';
import '../../screens/chat-screens/chat-screen.dart';


class CustomExploreListViewOfUsersWidget extends StatefulWidget {
  const CustomExploreListViewOfUsersWidget({super.key});

  @override
  _CustomExploreListViewOfUsersWidgetState createState() =>
      _CustomExploreListViewOfUsersWidgetState();
}

class _CustomExploreListViewOfUsersWidgetState
    extends State<CustomExploreListViewOfUsersWidget> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is FetchUsersError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        if (state is FetchUsersLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is FetchUsersSuccess) {
          final users = state.users;
          return SizedBox(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen( receiverId:users[index].uid.toString() ,senderId:currentUser,)));
                    },
                    child: Container(
                      child: ListTile(
                        leading: Container(
                            height: 50.h,
                            width: 50.w,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: users[index].profilePhoto!.isNotEmpty?Image.network(
                              users[index].profilePhoto.toString(),
                              fit: BoxFit.fill,
                            ):Icon(Icons.person_outline,size: 28,)
                        ),
                        title: Text(users[index].username ?? ''),
                        subtitle: Text(users[index].name ?? ''),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
        if (state is FetchUsersError) {
          return Center(
            child: Text(
              'Error loading users. Please try again.',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        return Container();
      },
    );
  }
}