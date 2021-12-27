import 'package:flutter/material.dart';

class DateNavigation extends StatelessWidget {
  final VoidCallback leftAction;
  final VoidCallback leftLongPressAction;
  final VoidCallback rightAction;

  const DateNavigation({
    Key? key,
    required Function() this.leftAction,
    required Function() this.leftLongPressAction,
    required Function() this.rightAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 56,
          height: 56,
          child: Material(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(56 / 2),
                bottomLeft: Radius.circular(56 / 2)),
            color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            child: InkWell(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(56 / 2),
                  bottomLeft: Radius.circular(56 / 2)),
              child: Icon(Icons.chevron_left,
                  color: Theme.of(context)
                      .floatingActionButtonTheme
                      .foregroundColor),
              onTap: leftAction,
              onLongPress: leftLongPressAction,
            ),
          ),
        ),
        SizedBox(
          width: 56,
          height: 56,
          child: Material(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(56 / 2),
                bottomRight: Radius.circular(56 / 2)),
            color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            child: InkWell(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(56 / 2),
                  bottomRight: Radius.circular(56 / 2)),
              child: Icon(Icons.chevron_right,
                  color: Theme.of(context)
                      .floatingActionButtonTheme
                      .foregroundColor),
              onTap: rightAction,
            ),
          ),
        ),
      ],
    );
  }
}
