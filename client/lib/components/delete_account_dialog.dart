import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todoaholic/screens/routes.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text(
        'Are your sure you want to delete your account?',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton.icon(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateColor.resolveWith((states) => Colors.red),
          ),
          onPressed: () async {
            HapticFeedback.heavyImpact();
            Navigator.pushReplacementNamed(context, Routes.auth);
            FirebaseAuth.instance.currentUser?.delete();
          },
          icon: const Icon(Icons.delete),
          label: const Text('Delete account'),
        ),
        OutlinedButton(
          child: const Text('Cancel'),
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.of(context).pop();
          },
        ),
      ],
      actionsPadding: const EdgeInsets.only(bottom: 10),
      contentPadding: EdgeInsets.zero,
      content: const Padding(
        padding: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
        child: Text(
            'This action will remove all your user data and cannot be undone.',
            textAlign: TextAlign.center),
      ),
    );
  }
}
