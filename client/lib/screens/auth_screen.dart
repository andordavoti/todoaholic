import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:todoaholic/screens/routes.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      actions: [
        AuthStateChangeAction<SignedIn>((context, _) {
          Navigator.of(context).pushReplacementNamed(Routes.home);
        }),
      ],
      providers: [EmailAuthProvider()],
    );
  }
}
