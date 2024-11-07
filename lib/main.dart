import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/presentation/screens/home-screens/add-screen.dart';
import 'package:instagramclone/presentation/screens/home-screens/home-screen.dart';
import 'package:instagramclone/presentation/screens/profile-screens/edit-profile-screen.dart';
import 'package:instagramclone/shared/bottom-navigation-bar.dart';
import 'logic/auth-cubit/auth_cubit.dart';
import 'presentation/screens/auth-screens/login-screen.dart';
import 'presentation/screens/auth-screens/register-screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCubit()),
        ],
        child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: "login",
              routes: {
                "login": (context) => const LoginScreen(),
                "register": (context) => const RegisterScreen(),
                "main_screen": (context) => const BottomTabs(),
                "home": (context) =>  HomeScreen(),
                "add_post" : (context) => const AddPostScreen(),
                "edit_profile" :(context) => const EditProfileScreen()

              },
            );
          },
        ));
  }
}

//return ScreenUtilInit(
//       designSize: const Size(360, 690),
//       minTextAdapt: true,
//       splitScreenMode: true,
//       builder: (_, child) {
//         return MaterialApp(
//           debugShowCheckedModeBanner: false,
//           home: const loginScreen(),
//           initialRoute: "login",
//           routes: {
//             "login": (context) => const loginScreen(),
//             "register" : (context) => const registerScreen(),
//             "home":(context)=> const homeScreen(),
//           },
//         );
//       },
//     );
