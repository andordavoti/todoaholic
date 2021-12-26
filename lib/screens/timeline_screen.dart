import 'package:flutter/material.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            color: Colors.transparent,
            icon: const Icon(Icons.check),
            onPressed: () {},
          )
        ],
        title: const Align(
            alignment: Alignment.topCenter, child: Text('Timeline')),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
