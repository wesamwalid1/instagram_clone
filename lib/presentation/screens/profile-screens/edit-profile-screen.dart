import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/generated/l10n.dart';
import '../../../logic/auth-cubit/auth_cubit.dart';
import '../../../shared/bottom-navigation-bar.dart';
import '../../widgets/edit-profile-widgets/custom-app-bar-widget.dart';
import '../../widgets/edit-profile-widgets/custom-text-field-widget.dart';
import '../../widgets/edit-profile-widgets/profile-photo-widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController bioController;
  late TextEditingController phoneController;
  late TextEditingController genderController;
  late TextEditingController websiteController;

  @override
  void initState() {
    super.initState();
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    context.read<AuthCubit>().fetchUserInfo(uid);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess || state is AuthProfileUpdateSuccess) {
          // Populate controllers with user data when fetch is successful or after an update
          if (state is AuthSuccess) {
            nameController =
                TextEditingController(text: state.userModel?.name ?? '');
            usernameController =
                TextEditingController(text: state.userModel?.username ?? '');
            emailController =
                TextEditingController(text: state.userModel?.email ?? '');
            bioController =
                TextEditingController(text: state.userModel?.bio ?? '');
            phoneController =
                TextEditingController(text: state.userModel?.phone ?? '');
            genderController =
                TextEditingController(text: state.userModel?.gender ?? '');
            websiteController =
                TextEditingController(text: state.userModel?.website ?? '');
          }
        } else if (state is AuthProfilePhotoUpdateSuccess) {
          // Navigate back to EditProfileScreen when profile photo is updated
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => EditProfileScreen()));
        } else if (state is AuthFailure) {
          // Show error message on failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthSuccess || state is AuthProfileUpdateSuccess) {
          return Scaffold(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 40.h, left: 20.w, right: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomAppBarEditProfileScreen(
                      onDone: () {
                        context.read<AuthCubit>().updateProfile(
                          name: nameController.text,
                          username: usernameController.text,
                          bio: bioController.text,
                          phone: phoneController.text,
                          gender: genderController.text,
                          website: websiteController.text,
                        );
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BottomTabs()));
                      },
                      onCancel: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    const ProfilePhotoWidget(),
                    CustomTextFieldWidget(
                      controller: nameController,
                      title: S.of(context).Name,
                      hint: "Enter Your Name",
                    ),
                    SizedBox(height: 10.h),
                    CustomTextFieldWidget(
                      controller: usernameController,
                      title: S.of(context).Username,
                      hint: "Enter Your username",
                    ),
                    SizedBox(height: 10.h),
                    CustomTextFieldWidget(
                      controller: websiteController,
                      title: S.of(context).Website,
                      hint: "Enter Your Website",
                    ),
                    CustomTextFieldWidget(
                      controller: bioController,
                      title: S.of(context).Bio,
                      hint: "Enter Your Bio",
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      S.of(context).Switch_to_Professional_Account,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDarkMode
                            ? Colors.blue[200]
                            : const Color.fromRGBO(56, 151, 240, 1),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      S.of(context).Private_Information,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: isDarkMode
                            ? Colors.white70
                            : const Color.fromRGBO(38, 38, 38, 1),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    CustomTextFieldWidget(
                      controller: emailController,
                      title: S.of(context).Email,
                      hint: "Enter Your Email",
                    ),
                    CustomTextFieldWidget(
                      controller: phoneController,
                      title: S.of(context).Phone,
                      hint: "Enter Your Phone number",
                    ),
                    CustomTextFieldWidget(
                      controller: genderController,
                      title: S.of(context).Gender,
                      hint: "Enter Your Gender",
                    ),
                    SizedBox(height: 200.h),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
