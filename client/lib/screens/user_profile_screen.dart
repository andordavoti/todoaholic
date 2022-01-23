import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:todoaholic/components/app_drawer.dart';
import 'package:todoaholic/components/delete_account_dialog.dart';
import 'package:todoaholic/components/verify_email_dialog.dart';
import 'package:todoaholic/main.dart';
import 'package:todoaholic/screens/routes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import 'package:flutterfire_ui/auth.dart';

import 'auth_screen.dart';

class TasksIntent extends Intent {}

class TimelineIntent extends Intent {}

class UserProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

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

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const AuthScreen()
              : Shortcuts(
                  shortcuts: {
                    LogicalKeySet(LogicalKeyboardKey.keyH): TasksIntent(),
                    LogicalKeySet(LogicalKeyboardKey.keyT): TimelineIntent(),
                  },
                  child: Actions(
                    actions: {
                      TasksIntent: CallbackAction<TasksIntent>(
                          onInvoke: (intent) => Navigator.pushReplacementNamed(
                              context, Routes.home)),
                      TimelineIntent: CallbackAction<TimelineIntent>(
                          onInvoke: (intent) => Navigator.pushReplacementNamed(
                              context, Routes.timeline)),
                    },
                    child: Focus(
                      autofocus: true,
                      child: Scaffold(
                          drawer: const AppDrawer(),
                          appBar: AppBar(
                            title: const Text('Profile'),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: (IconButton(
                                  icon: Icon(Icons.logout,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .color),
                                  onPressed: FirebaseAuth.instance.signOut,
                                )),
                              ),
                            ],
                          ),
                          body: StreamBuilder<User?>(
                              stream: FirebaseAuth.instance.userChanges(),
                              builder: (context, snapshot) {
                                final user = snapshot.data;
                                return ListView(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Center(
                                          child: UserAvatar(
                                            size: 81,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 16.0),
                                          child: EditableUserDisplayName(),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 32),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              LinkedProvidersRow(
                                                  providerConfigs:
                                                      MyApp.providerConfigs),
                                            ],
                                          ),
                                        ),
                                        user != null &&
                                                user.emailVerified == false
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 32, bottom: 8),
                                                child: SizedBox(
                                                  width: 275,
                                                  child: OutlinedButton.icon(
                                                      onPressed: () async {
                                                        HapticFeedback
                                                            .selectionClick();
                                                        await user
                                                            .sendEmailVerification();

                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return VerifyEmailDialog(
                                                                okAction:
                                                                    () async {
                                                                  user.reload();
                                                                },
                                                              );
                                                            });
                                                      },
                                                      icon: const Icon(MdiIcons
                                                          .emailAlertOutline),
                                                      label: const Text(
                                                          'Verify email')),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 32),
                                          child: RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text: 'Developed by ',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6),
                                                TextSpan(
                                                    text: 'Davoti Solutions',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6!
                                                        .copyWith(
                                                            fontFamily:
                                                                'mustang')),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16, bottom: 8),
                                            child: TouchableOpacity(
                                              activeOpacity: 0.4,
                                              onTap: () {
                                                launch(
                                                    'https://davotisolutions.com/');
                                              },
                                              child: Text(
                                                'www.davotisolutions.com',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText2!
                                                    .copyWith(
                                                        color: isDarkMode
                                                            ? Colors
                                                                .lightBlueAccent
                                                            : Colors.blue),
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 16, bottom: 16),
                                          child: SizedBox(
                                            width: 275,
                                            child: OutlinedButton.icon(
                                                icon: const Icon(
                                                    Icons.email_outlined),
                                                onPressed: () {
                                                  final Uri emailLaunchUri =
                                                      Uri(
                                                    scheme: 'mailto',
                                                    path:
                                                        'contact@davotisolutions.com',
                                                    query:
                                                        encodeQueryParameters(<
                                                            String, String>{
                                                      'subject':
                                                          'Regarding todoaholic'
                                                    }),
                                                  );

                                                  launch(emailLaunchUri
                                                      .toString());
                                                },
                                                label:
                                                    const Text('Contact us')),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8, bottom: 16),
                                            child: SizedBox(
                                              width: 275,
                                              child: OutlinedButton.icon(
                                                  onPressed: () {
                                                    launch(
                                                        'https://github.com/andordavoti/todoaholic');
                                                  },
                                                  icon: const Icon(
                                                      MdiIcons.github),
                                                  label: const Text(
                                                      'Source-Code on GitHub')),
                                            )),
                                        kIsWeb
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8, bottom: 16),
                                                child: SizedBox(
                                                  width: 275,
                                                  child: OutlinedButton.icon(
                                                      onPressed: () {
                                                        launch(
                                                            'https://www.buymeacoffee.com/andordavoti');
                                                      },
                                                      icon: const Icon(
                                                          MdiIcons.beerOutline),
                                                      label: const Text(
                                                          'Buy me a beer')),
                                                ),
                                              )
                                            : const SizedBox.shrink(),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Version: ${packageInfo?.version ?? ''}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, bottom: 16),
                                          child: SizedBox(
                                            width: 275,
                                            child: OutlinedButton.icon(
                                              style: ButtonStyle(
                                                foregroundColor:
                                                    MaterialStateColor
                                                        .resolveWith((states) =>
                                                            Colors.red),
                                              ),
                                              onPressed: () {
                                                HapticFeedback.mediumImpact();
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return const DeleteAccountDialog();
                                                    });
                                              },
                                              icon: const Icon(Icons.delete),
                                              label:
                                                  const Text('Delete account'),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]);
                              })),
                    ),
                  ),
                );
        });
  }
}
