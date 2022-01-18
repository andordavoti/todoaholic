import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/lists_dao.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:todoaholic/screens/custom_list_screen.dart';
import 'package:todoaholic/screens/home.dart';
import 'package:todoaholic/screens/screen_routes.dart';
import 'package:todoaholic/screens/timeline_screen.dart';
import 'package:todoaholic/screens/user_profile_screen.dart';
import 'package:todoaholic/utils/theme.dart';
import 'data/custom_list_dao.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppState(),
        ),
        Provider<TodoDao>(
          lazy: true,
          create: (_) => TodoDao(),
        ),
        Provider<ListsDao>(
          lazy: true,
          create: (_) => ListsDao(),
        ),
        Provider<CustomListDao>(
          lazy: true,
          create: (_) => CustomListDao(),
        ),
      ],
      child: MaterialApp(
        title: 'todoaholic',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        debugShowCheckedModeBanner: false,
        initialRoute: FirebaseAuth.instance.currentUser == null
            ? ScreenRoutes.auth
            : ScreenRoutes.home,
        routes: {
          ScreenRoutes.auth: (context) => SignInScreen(
                actions: [
                  AuthStateChangeAction<SignedIn>((context, _) {
                    Navigator.of(context)
                        .pushReplacementNamed(ScreenRoutes.home);
                  }),
                ],
                providerConfigs: const [
                  EmailProviderConfiguration(),
                ],
              ),
          ScreenRoutes.home: (context) => Home(),
          ScreenRoutes.timeline: (context) => const TimelineScreen(),
          //  ScreenRoutes.customList: (context) => const CustomListScreen(),
          ScreenRoutes.profile: (context) => const UserProfileScreen(),
        },
      ),
    );
  }
}
