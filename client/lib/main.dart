import 'dart:io' show Platform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/lists_dao.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:todoaholic/screens/routes.dart';
import 'package:todoaholic/utils/theme.dart';
import 'data/custom_list_dao.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      setWindowMinSize(const Size(400, 300));
      setWindowMaxSize(Size.infinite);
    }
    // ignore: empty_catches
  } catch (e) {}

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final providerConfigs = [
    const EmailProviderConfiguration(),
  ];

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
      child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return MaterialApp(
              title: 'todoaholic',
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              debugShowCheckedModeBanner: false,
              initialRoute: !snapshot.hasData ? Routes.auth : Routes.home,
              routes: Routes.appRoutes,
            );
          }),
    );
  }
}
