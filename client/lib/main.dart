import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:todoaholic/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/lists_dao.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:todoaholic/utils/theme.dart';
import 'data/custom_list_dao.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

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
        home: Home(),
      ),
    );
  }
}
