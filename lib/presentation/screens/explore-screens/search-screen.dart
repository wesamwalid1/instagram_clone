import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/auth-cubit/auth_cubit.dart';
import '../profile-screens/users-profile-screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Request focus for the search field on screen load
    Future.delayed(Duration.zero, () {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Function to initiate search
  void _onSearchChanged(String query) {
    // Trigger the search in AuthCubit
    String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    context.read<AuthCubit>().searchUsers(query, currentUserUid);
  }

  @override
  Widget build(BuildContext context) {
    // Get the current theme (dark or light mode)
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Set the background color based on the theme mode
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;

    // Set text color based on the theme mode
    final textColor = isDarkMode ? Colors.white : Colors.black;

    // Set the input field decoration based on the theme mode
    final inputFieldColor = isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300;
    final borderColor = isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.only(top: 35.h, left: 10.w, right: 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: 35.h,
                  width: 276.w,
                  decoration: BoxDecoration(
                    color: inputFieldColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    // Trigger search on text change
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(fontSize: 13.sp, color: textColor),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: borderColor)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: borderColor, // Border color when TextField is enabled (but not focused)
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: borderColor)),
                      contentPadding: EdgeInsets.symmetric(vertical: 13.h),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 10.sp, color: textColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),

            // BlocBuilder to listen to search results
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AuthSearchResults) {
                  if (state.searchResults.isEmpty) {
                    return Center(
                      child: Text(
                        "No users found",
                        style: TextStyle(fontSize: 18.sp, color: textColor),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.searchResults.length,
                      itemBuilder: (context, index) {
                        final user = state.searchResults[index];
                        return ListTile(
                          title: Text(user.username!, style: TextStyle(color: textColor)),
                          subtitle: Text(user.name ?? 'No Name', style: TextStyle(color: textColor)),
                          leading: CircleAvatar(
                            backgroundImage: user.profilePhoto != null
                                ? NetworkImage(user.profilePhoto!)
                                : null,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UsersProfileScreen(
                                      user: user,
                                    )));
                          },
                        );
                      },
                    ),
                  );
                } else if (state is AuthFailure) {
                  return Center(child: Text("Error: ${state.error}", style: TextStyle(color: textColor)));
                }
                return const SizedBox(); // Placeholder when no results
              },
            ),
          ],
        ),
      ),
    );
  }
}
