import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/auth-cubit/auth_cubit.dart';
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
    context.read<AuthCubit>().fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess || state is AuthProfileUpdateSuccess) {
          // Populate controllers with user data when fetch is successful or after an update
          if (state is AuthSuccess) {
            nameController = TextEditingController(text: state.userModel?.name ?? '');
            usernameController = TextEditingController(text: state.userModel?.username ?? '');
            emailController = TextEditingController(text: state.userModel?.email ?? '');
            bioController = TextEditingController(text: state.userModel?.bio ?? '');
            phoneController = TextEditingController(text: state.userModel?.phone ?? '');
            genderController = TextEditingController(text: state.userModel?.gender ?? '');
            websiteController = TextEditingController(text: state.userModel?.website ?? '');
          }
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
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("Edit Profile"),
              actions: [
                TextButton(
                  onPressed: () {
                    // Trigger the updateProfile function when "Done" is pressed
                    context.read<AuthCubit>().updateProfile(
                      name: nameController.text,
                      username: usernameController.text,
                      bio: bioController.text,
                      phone: phoneController.text,
                      gender: genderController.text,
                      website: websiteController.text,
                    );
                  },
                  child: const Text(
                    "Done",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  children: [
                    const ProfilePhotoWidget(),
                    SizedBox(height: 20.h),
                    CustomTextFieldWidget(
                      controller: nameController,
                      title: "Name",
                    ),
                    SizedBox(height: 10.h),
                    CustomTextFieldWidget(
                      controller: usernameController,
                      title: "Username",
                    ),
                    SizedBox(height: 10.h),
                    CustomTextFieldWidget(
                      controller: websiteController,
                      title: "Website",
                    ),
                    CustomTextFieldWidget(
                      controller: bioController,
                      title: "Bio",
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      "Switch to Professional Account",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: const Color.fromRGBO(56, 151, 240, 1),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Private Information",
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: const Color.fromRGBO(38, 38, 38, 1),
                      ),
                    ),
                    CustomTextFieldWidget(
                      controller: emailController,
                      title: "Email",
                    ),
                    CustomTextFieldWidget(
                      controller: phoneController,
                      title: "Phone",
                    ),
                    CustomTextFieldWidget(
                      controller: genderController,
                      title: "Gender",
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
