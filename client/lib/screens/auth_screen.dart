import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:todoaholic/screens/routes.dart';

import '../main.dart';

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
      providerConfigs: MyApp.providerConfigs,
    );
  }
}
