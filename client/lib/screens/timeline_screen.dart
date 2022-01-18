import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/components/app_drawer.dart';

import 'package:todoaholic/components/past_todo_list.dart';
import 'package:todoaholic/components/timeline_todo_list.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:todoaholic/data/todo_item_type.dart';
import 'package:todoaholic/screens/screen_routes.dart';

class TasksIntent extends Intent {}

class ProfileIntent extends Intent {}

class TimelineScreen extends StatelessWidget {
  static const String routeName = '/timeline';

  const TimelineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();
    final todoDao = Provider.of<TodoDao>(context, listen: false);
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.keyH): TasksIntent(),
        LogicalKeySet(LogicalKeyboardKey.keyP): ProfileIntent(),
      },
      child: Actions(
        actions: {
          TasksIntent: CallbackAction<TasksIntent>(
              onInvoke: (intent) =>
                  Navigator.pushReplacementNamed(context, ScreenRoutes.home)),
          ProfileIntent: CallbackAction<ProfileIntent>(
              onInvoke: (intent) => Navigator.pushReplacementNamed(
                  context, ScreenRoutes.profile)),
        },
        child: Focus(
          autofocus: true,
          child: Scaffold(
            drawer: const AppDrawer(),
            appBar: AppBar(
              actions: const [
                IconButton(
                  color: Colors.transparent,
                  icon: SizedBox.shrink(),
                  onPressed: null,
                )
              ],
              title: const Align(
                  alignment: Alignment.topCenter, child: Text('Timeline')),
            ),
            body: StreamBuilder<QuerySnapshot>(
                stream: todoDao.getUndonePastStream(),
                builder: (context, pastSnapshot) {
                  final bool pastTasksExist = pastSnapshot.hasData &&
                      pastSnapshot.data!.docs.isNotEmpty;
                  return pastTasksExist
                      ? SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          controller: _scrollController,
                          child: Column(
                            children: [
                              const PastTodoList(type: TodoItemType.past),
                              TimelineTodoList(noPastTasks: false),
                            ],
                          ),
                        )
                      : TimelineTodoList(noPastTasks: true);
                }),
          ),
        ),
      ),
    );
  }
}
