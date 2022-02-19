import 'package:flutter/material.dart';
import 'package:todoaholic/screens/custom_list_screen.dart';
import 'package:todoaholic/screens/timeline_screen.dart';
import 'package:todoaholic/screens/user_profile_screen.dart';

import 'home.dart';

class Routes {
  static const String home = Home.routeName;
  static const String timeline = TimelineScreen.routeName;
  static const String profile = UserProfileScreen.routeName;
  static const String customList = CustomListScreen.routeName;

  static Map<String, Widget Function(BuildContext)> appRoutes = {
    Routes.home: (context) => const Home(),
    Routes.timeline: (context) => const TimelineScreen(),
    Routes.customList: (context) => const CustomListScreen(),
    Routes.profile: (context) => const UserProfileScreen(),
  };
}
