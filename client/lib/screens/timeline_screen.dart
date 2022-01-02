import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:todoaholic/components/past_todo_list.dart';
import 'package:todoaholic/components/timeline_todo_list.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:todoaholic/data/todo_item_type.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    final todoDao = Provider.of<TodoDao>(context, listen: false);
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
      body: StreamBuilder<QuerySnapshot>(
          stream: todoDao.getUndonePastStream(),
          builder: (context, pastSnapshot) {
            final bool pastTasksExist =
                pastSnapshot.hasData && pastSnapshot.data!.docs.isNotEmpty;
            return pastTasksExist
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: _scrollController,
                    child: Column(
                      children: [
                        const PastTodoList(type: TodoItemType.pastTimeline),
                        TimelineTodoList(noPastTasks: false),
                      ],
                    ),
                  )
                : TimelineTodoList(noPastTasks: true);
          }),
    );
  }
}
