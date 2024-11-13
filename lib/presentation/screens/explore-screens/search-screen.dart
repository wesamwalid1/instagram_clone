import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/auth-cubit/auth_cubit.dart';

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
    context.read<AuthCubit>().searchUsers(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _searchController,
                    onChanged: _onSearchChanged, // Trigger search on text change
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(fontSize: 13.sp),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: const BorderSide(color: Colors.red)),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,  // Border color when TextField is enabled (but not focused)
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: Colors.grey.shade300)),
                      contentPadding: EdgeInsets.symmetric(vertical: 13.h),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Colors.black,
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
                    style: TextStyle(fontSize: 10.sp, color: Colors.black),
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
                    return const Center(child: Text("No users found"));
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: state.searchResults.length,
                      itemBuilder: (context, index) {
                        final user = state.searchResults[index];
                        return ListTile(
                          title: Text(user.username!),
                          subtitle: Text(user.name ?? 'No Name'),
                          leading: CircleAvatar(
                            backgroundImage: user.profilePhoto != null
                                ? NetworkImage(user.profilePhoto!)
                                : null,
                          ),
                          onTap: () {
                            // Navigate to user profile or details page
                          },
                        );
                      },
                    ),
                  );
                } else if (state is AuthFailure) {
                  return Center(child: Text("Error: ${state.error}"));
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
