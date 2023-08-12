import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:todoaholic/components/delete_account_dialog.dart';
import 'package:todoaholic/components/scaffold_wrapper.dart';
import 'package:todoaholic/components/verify_email_dialog.dart';
import 'package:todoaholic/screens/timeline_screen.dart';
import 'package:todoaholic/utils/create_route.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../constants.dart';
import 'auth_screen.dart';
import 'home.dart';

class TasksIntent extends Intent {}

class TimelineIntent extends Intent {}

class UserProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  PackageInfo? packageInfo;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
                          onInvoke: (intent) =>
                              Navigator.of(context).push(createRoute(Home()))),
                      TimelineIntent: CallbackAction<TimelineIntent>(
                        onInvoke: (intent) => Navigator.of(context)
                            .push(createRoute(const TimelineScreen())),
                      ),
                    },
                    child: Focus(
                        autofocus: true,
                        child: ScaffoldWrapper(
                          title: 'Profile',
                          actions: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: (IconButton(
                                icon: Icon(Icons.logout,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color),
                                onPressed: FirebaseAuth.instance.signOut,
                              )),
                            ),
                          ],
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
                                        const Padding(
                                          padding: EdgeInsets.only(top: 32),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              // LinkedProvidersRow(),
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
                                                        user.sendEmailVerification();

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
                                                      icon: Icon(MdiIcons
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
                                                        .titleLarge),
                                                TextSpan(
                                                    text: 'Davoti Solutions',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .titleLarge!
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
                                                launchUrlString(
                                                    companyWebsiteUrl);
                                              },
                                              child: Text(
                                                'www.davotisolutions.com',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium!
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
                                                    path: contactEmail,
                                                    query:
                                                        encodeQueryParameters(<String,
                                                            String>{
                                                      'subject':
                                                          'Regarding todoaholic'
                                                    }),
                                                  );

                                                  launchUrl(emailLaunchUri);
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
                                                    launchUrlString(
                                                        githubRepoUrl);
                                                  },
                                                  icon: Icon(MdiIcons.github),
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
                                                        launchUrlString(
                                                            donationUrl);
                                                      },
                                                      icon: Icon(
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
                                                .bodyLarge,
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
                              }),
                        )),
                  ),
                );
        });
  }
}
