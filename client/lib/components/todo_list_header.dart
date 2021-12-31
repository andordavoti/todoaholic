import 'package:flutter/material.dart';

class TodoListHeader extends StatelessWidget {
  final String title;

  const TodoListHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline2,
          ),
        ),
      ),
    );
  }
}
