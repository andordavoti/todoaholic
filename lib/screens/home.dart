import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class Home extends StatelessWidget {
  final AsyncSnapshot<User?> user;

  const Home(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileImg = user.data?.photoURL;

    return Scaffold(
      appBar: AppBar(
        title: const Text('todoaholic'),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                customBorder: const CircleBorder(),
                child: profileImg == null
                    ? (const CircleAvatar(
                        child: Icon(Icons.person),
                        backgroundColor: Colors.amber,
                        radius: 18,
                      ))
                    : CircleAvatar(
                        backgroundImage: NetworkImage(profileImg),
                      ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        providerConfigs: [EmailProviderConfiguration()],
                        avatarSize: 100,
                        actions: [
                          SignedOutAction((context) {
                            Navigator.of(context).pop();
                          }),
                        ],
                      ),
                    ),
                  );
                },
              ))
        ],
      ),
    );
  }
}
