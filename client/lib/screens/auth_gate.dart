import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoaholic/screens/auth_screen.dart';
import 'package:todoaholic/screens/home.dart';

class AuthGate extends StatelessWidget {
  static const String routeName = '/authGate';

  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return snapshot.hasData ? Home() : const AuthScreen();
        });
  }
}
