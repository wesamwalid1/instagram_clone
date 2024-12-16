import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/auth-cubit/auth_cubit.dart';
import '../../../logic/stories-cubit/stories_cubit.dart';
import '../../../logic/stories-cubit/stories_state.dart';
import '../../screens/home-screens/add-story-screen.dart';
import '../../screens/home-screens/story-view-screen.dart';

class CustomStoriesListView extends StatefulWidget {
  const CustomStoriesListView({super.key});

  @override
  State<CustomStoriesListView> createState() => _CustomStoriesListViewState();
}

class _CustomStoriesListViewState extends State<CustomStoriesListView> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    // Fetch user info to retrieve the current user's ID
    context.read<AuthCubit>().fetchUserInfo(uid);

    // After fetching user info, listen to updates to get the user ID
    context.read<AuthCubit>().stream.listen((authState) {
      if (authState is AuthSuccess) {
        setState(() {
          currentUserId = authState.user.uid;
        });
        // Fetch stories only after user info is loaded and currentUserId is set
        if (currentUserId != null) {
          context.read<StoryCubit>().fetchAllStories(currentUserId!);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ));
    }

    // Determine the current theme's primary color for dynamic styling
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDarkMode ? Colors.white : Colors.black;

    return BlocConsumer<StoryCubit, StoryState>(
      listener: (context, state) {
        if (state is StoryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        if (state is StoryLoading) {
          return const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ));
        } else if (state is StoriesLoaded) {
          final stories = state.stories;
          final userHasStory = state.userHasStory;

          // Create a set of unique users who have shared stories
          final usersWithStories = <String>{};
          for (var story in stories) {
            if (currentUserId != story.userId) {
              usersWithStories.add(story.userId!);
            }
          }
          final userStories = stories.where((s) => s.userId == currentUserId).toList();
          final usersStories = stories.where((s) => s.userId != currentUserId).toList();

          return SizedBox(
            height: 90.h,
            width: MediaQuery.of(context).size.width.w,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: usersWithStories.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // Show the current user's story with blue "Add Story" icon or long-press option
                  return GestureDetector(
                    onTap: () {
                      if (userHasStory) {
                        // Navigate to view the user's existing story
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                StoryViewScreen(stories: userStories),
                          ),
                        );
                      } else {
                        // Navigate to add a new story
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddStoryScreen(),
                          ),
                        );
                      }
                    },
                    onLongPress: () {
                      // Allow long press to add a new story for the current user
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddStoryScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.0.h, vertical: 4.w),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 72.w,
                            child: Stack(
                              children: [
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  width: 60.w,
                                  height: 60.h,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: BlocConsumer<AuthCubit, AuthState>(
                                    builder: (context, state) {
                                      String profilePhotoUrl =
                                          'assets/images/default_profile.png';
                                      if (state is AuthSuccess &&
                                          state.userModel != null) {
                                        profilePhotoUrl = (state.userModel!
                                            .profilePhoto!.isNotEmpty
                                            ? state.userModel!.profilePhoto
                                            : profilePhotoUrl)!;
                                      }
                                      return profilePhotoUrl.startsWith('http')
                                          ? Image.network(
                                        profilePhotoUrl,
                                        fit: BoxFit.cover,
                                      )
                                          : Image.asset(
                                        profilePhotoUrl,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                    listener: (context, state) {},
                                  ),
                                ),
                                if (!userHasStory)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 25.w,
                                      height: 25.h,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black,
                                          border: Border.all(
                                              color: Colors.white, width: 2)),
                                      child: Icon(Icons.add,
                                          color: Colors.white, size: 12.sp),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Your Story',
                            style: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return usersStories.isNotEmpty
                      ? GestureDetector(
                    onTap: () {
                      // Navigate to view the selected user's story
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StoryViewScreen(stories: usersStories),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                clipBehavior: Clip.antiAlias,
                                width: 60.w,
                                height: 60.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.network(
                                  stories[index].profilePhoto ?? '',
                                  fit: BoxFit.fill,
                                  errorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .brightness ==
                                                    Brightness.light
                                                    ? Colors.grey
                                                    .withOpacity(0.2)
                                                    : Colors.grey
                                                    .withOpacity(
                                                    0.5))),
                                        child:
                                        const Icon(Icons.person_outline));
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            stories[index].username.toString(),
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  )
                      : SizedBox();
                }
              },
            ),
          );
        } else {
          return const Center(child: Text('No stories to show'));
        }
      },
    );
  }
}
