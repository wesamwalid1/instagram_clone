import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/logic/auth-cubit/auth_cubit.dart';
import 'package:instagramclone/presentation/screens/explore-screens/explore-screen.dart';
import '../presentation/screens/home-screens/home-screen.dart';
import '../presentation/screens/profile-screens/profile-screen.dart';

class BottomTabs extends StatefulWidget {
  const BottomTabs({super.key});

  @override
  State<BottomTabs> createState() => _BottomTabsState();
}

class _BottomTabsState extends State<BottomTabs> {
  final List <Widget>_pages=[
    HomeScreen(),
    ExploreScreen(),
    Container(color: Colors.red,),
    Container(color: Colors.blue,),
    ProfileScreen(),



  ];
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit,AuthState>(
        builder: (context,state){
          String profilePhotoUrl = 'assets/images/default_profile.png';
          // Check if we have a successful state with user info
          if (state is AuthSuccess && state.userModel != null) {
            profilePhotoUrl = (state.userModel!.profilePhoto!.isNotEmpty
                ? state.userModel!.profilePhoto
                : profilePhotoUrl)!;
          }
          return Scaffold(

            body: _pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                onTap: (index){
                  setState(() {
                    _selectedIndex=index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Image.asset( _selectedIndex == 0 ? "assets/images/home-icon.png":"assets/images/home-icon.png",),
                      label: ""
                  ),
                  BottomNavigationBarItem(
                      icon: Image.asset( _selectedIndex == 1 ? "assets/images/search-icon.png":"assets/images/search-icon.png",fit: BoxFit.fill,),
                      label: ""
                  ),
                  BottomNavigationBarItem(
                      icon: Image.asset( _selectedIndex == 2 ? "assets/images/reels-icon.png":"assets/images/reels-icon.png"),
                      label: ""
                  ),
                  BottomNavigationBarItem(
                      icon: Image.asset( _selectedIndex == 3 ? "assets/images/shop-icon.png":"assets/images/shop-icon.png"),
                      label: ""
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                      height: 25.h,
                      width: 25.h,
                      clipBehavior: Clip.antiAlias,
                      decoration:  const BoxDecoration(
                          shape: BoxShape.circle),
                      child:profilePhotoUrl.startsWith('http')
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
                  )
                ]),
          );
        }, listener: (context,state){});
  }
}

