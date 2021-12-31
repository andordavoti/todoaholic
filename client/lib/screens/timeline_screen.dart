import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todoaholic/components/past_todo_list.dart';
import 'package:todoaholic/components/timeline_todo_list.dart';
import 'package:todoaholic/data/todo_item_type.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          HapticFeedback.selectionClick();
          Navigator.pop(context);
        }),
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        child: Column(
          children: [
            const PastTodoList(type: TodoItemType.pastTimeline),
            TimelineTodoList(noPastTasks: false),
          ],
        ),
      ),
    );
  }
}
