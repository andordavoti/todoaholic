import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerifyEmailDialog extends StatelessWidget {
  final VoidCallback okAction;

  const VerifyEmailDialog({
    Key? key,
    required Function() this.okAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      title: const Text(
        'Please check your email',
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        OutlinedButton(
          child: const Text('I have opened the link'),
          onPressed: () {
            okAction();
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
            'Please check your email and click on the link to verify your email address.',
            textAlign: TextAlign.center),
      ),
    );
  }
}
