import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/logic/auth-cubit/auth_cubit.dart';
import 'package:instagramclone/presentation/screens/explore-screens/explore-screen.dart';
import '../presentation/screens/home-screens/add-screen.dart';
import '../presentation/screens/home-screens/home-screen.dart';
import '../presentation/screens/profile-screens/profile-screen.dart';

class BottomTabs extends StatefulWidget {
  const BottomTabs({super.key});

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  final List<Widget> _pages = [
    HomeScreen(),
    ExploreScreen(),
    AddScreen(),
    Container(
      color: Colors.blue,
    ),
    ProfileScreen(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final selectedIconColor = isDarkMode ? Colors.blueAccent : Colors.blue;

    return BlocConsumer<AuthCubit, AuthState>(
      builder: (context, state) {
        String profilePhotoUrl = 'assets/images/default_profile.png';
        // Check if we have a successful state with user info
        if (state is AuthSuccess && state.userModel != null) {
          profilePhotoUrl = (state.userModel!.profilePhoto!.isNotEmpty
              ? state.userModel!.profilePhoto
              : profilePhotoUrl)!;
        }
        return Scaffold(
          backgroundColor: backgroundColor,
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  _selectedIndex == 0
                      ? "assets/images/home-icon.png"
                      : "assets/images/iconsNotSelected/home-not-select.png",
                  color: _selectedIndex == 0 ? selectedIconColor : iconColor,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  _selectedIndex == 1
                      ? "assets/images/search-icon.png"
                      : "assets/images/iconsNotSelected/search-not-select.png",
                  fit: BoxFit.fill,
                  color: _selectedIndex == 1 ? selectedIconColor : iconColor,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  _selectedIndex == 2
                      ? "assets/images/add_icon.png"
                      : "assets/images/iconsNotSelected/add-not-select.png",
                  color: _selectedIndex == 2 ? selectedIconColor : iconColor,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  _selectedIndex == 3
                      ? "assets/images/likes.png"
                      : "assets/images/iconsNotSelected/likes-not-select.png",
                  color: _selectedIndex == 3 ? selectedIconColor : iconColor,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: _selectedIndex == 4
                    ? Container(
                  height: 25.h,
                  width: 25.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedIconColor, // Selected state color
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      height: 23.h,
                      width: 23.h,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: profilePhotoUrl.startsWith('http')
                          ? Image.network(
                        profilePhotoUrl,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        profilePhotoUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                    : Container(
                  height: 25.h,
                  width: 25.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: profilePhotoUrl.startsWith('http')
                      ? Image.network(
                    profilePhotoUrl,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    profilePhotoUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                label: "",
              ),
            ],
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
