import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:instagramclone/core/theme/app_theme.dart';
import 'package:instagramclone/logic/chat-cubit/chat_cubit.dart';
import 'package:instagramclone/logic/post-cubit/post_cubit.dart';
import 'package:instagramclone/logic/theme-cubit/theme_cubit.dart';
import 'package:instagramclone/presentation/screens/chat-screens/search-user-screen.dart';
import 'package:instagramclone/presentation/screens/home-screens/add-screen.dart';
import 'package:instagramclone/presentation/screens/home-screens/home-screen.dart';
import 'package:instagramclone/presentation/screens/profile-screens/edit-profile-screen.dart';
import 'package:instagramclone/presentation/screens/profile-screens/profile-screen.dart';
import 'package:instagramclone/presentation/screens/profile-screens/settings-screen.dart';
import 'package:instagramclone/shared/bottom-navigation-bar.dart';
import 'package:path_provider/path_provider.dart';
import 'data/cache/cache.dart';
import 'logic/auth-cubit/auth_cubit.dart';
import 'logic/stories-cubit/stories_cubit.dart';
import 'presentation/screens/auth-screens/login-screen.dart';
import 'presentation/screens/auth-screens/register-screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.cachIntialization();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
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
    var cache = CacheHelper();
    var token = cache.getData(key: 'auth_token');
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => AuthCubit()),
              BlocProvider(create: (context) => PostCubit()),
              BlocProvider(create: (context) => ThemeCubit()),
              BlocProvider(create: (context) => StoryCubit()),
              BlocProvider(create: (context) => ChatCubit())
            ],
            child: BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, mode) => MaterialApp(
                      debugShowCheckedModeBanner: false,
                      themeMode: mode,
                      darkTheme: AppTheme.DarkTheme,
                      theme: AppTheme.lightTheme,
                      initialRoute: token != null ? "main_screen" : "login",
                      // initialRoute: "profile",

                      routes: {
                        "login": (context) => const LoginScreen(),
                        "register": (context) => const RegisterScreen(),
                        "main_screen": (context) => const BottomTabs(),
                        "home": (context) => HomeScreen(),
                        "profile": (context) => const ProfileScreen(),
                        "add": (context) => const AddScreen(),
                        "edit_profile": (context) => const EditProfileScreen(),
                        //"users_profile": (context) => const UsersProfileScreen(),
                        "settings": (context) => const SettingsScreen(),
                        //"details" : (context) =>  DetailsScreen()
                        'searchUserScreen':(context)=>const DirectSearchUsersScreen()
                      },
                    )),
          );
        });
  }
}
