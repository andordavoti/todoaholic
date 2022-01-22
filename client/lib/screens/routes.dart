import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:todoaholic/screens/custom_list_screen.dart';
import 'package:todoaholic/screens/timeline_screen.dart';
import 'package:todoaholic/screens/user_profile_screen.dart';

import '../main.dart';
import 'home.dart';

class Routes {
  static const String auth = 'auth';
  static const String home = Home.routeName;
  static const String timeline = TimelineScreen.routeName;
  static const String profile = UserProfileScreen.routeName;
  static const String customList = CustomListScreen.routeName;

  static Future<String> getInitialRoute(bool isLoggedIn) async {
    return isLoggedIn ? home : auth;
  }

  static Map<String, Widget Function(BuildContext)> appRoutes = {
    Routes.auth: (context) => SignInScreen(
          actions: [
            AuthStateChangeAction<SignedIn>((context, _) {
              Navigator.of(context).pushReplacementNamed(Routes.home);
            }),
          ],
          providerConfigs: MyApp.providerConfigs,
        ),
    Routes.home: (context) => Home(),
    Routes.timeline: (context) => const TimelineScreen(),
    Routes.customList: (context) => const CustomListScreen(),
    Routes.profile: (context) => const UserProfileScreen(),
  };
}
