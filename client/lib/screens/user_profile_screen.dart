import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:flutterfire_ui/auth.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      PackageInfo info = await PackageInfo.fromPlatform();
      setState(() {
        packageInfo = info;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      providerConfigs: const [EmailProviderConfiguration()],
      avatarSize: 100,
      actions: [
        SignedOutAction((context) {
          HapticFeedback.heavyImpact();
          Navigator.of(context).pop();
        }),
      ],
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Version: ${packageInfo?.version ?? ''}",
            style: Theme.of(context).textTheme.bodyText1,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
