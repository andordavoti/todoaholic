import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:todoaholic/utils/theme.dart';
import 'components/authgate.dart';
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
      ],
      child: MaterialApp(
        title: 'todoaholic',
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const AuthGate(),
      ),
    );
  }
}
