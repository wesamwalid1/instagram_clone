import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/homeScreen.dart';
import 'package:instagramclone/test.dart';
import 'features/auth-feature/view-model/logic/auth-cubit/auth_cubit.dart';
import 'features/auth-feature/view/screens/login.dart';
import 'features/auth-feature/view/screens/register.dart';
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
              //home: const homeScreen(),
              initialRoute: "home",
              routes: {
                "login": (context) => const loginScreen(),
                "register": (context) => const registerScreen(),
                "home": (context) =>  homeScreen(),
                "test": (context) =>  test()
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
