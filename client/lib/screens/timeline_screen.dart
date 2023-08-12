import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/components/past_todo_list.dart';
import 'package:todoaholic/components/scaffold_wrapper.dart';
import 'package:todoaholic/components/timeline_todo_list.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:todoaholic/data/todo_item_type.dart';
import 'package:todoaholic/screens/user_profile_screen.dart';
import 'package:todoaholic/utils/create_route.dart';

import 'auth_screen.dart';
import 'home.dart';

class TasksIntent extends Intent {}

class ProfileIntent extends Intent {}

class TimelineScreen extends StatelessWidget {
  static const String routeName = '/timeline';

  const TimelineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final todoDao = Provider.of<TodoDao>(context, listen: false);
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const AuthScreen()
              : Shortcuts(
                  shortcuts: {
                    LogicalKeySet(LogicalKeyboardKey.keyH): TasksIntent(),
                    LogicalKeySet(LogicalKeyboardKey.keyP): ProfileIntent(),
                  },
                  child: Actions(
                    actions: {
                      TasksIntent: CallbackAction<TasksIntent>(
                        onInvoke: (intent) =>
                            Navigator.of(context).push(createRoute(Home())),
                      ),
                      ProfileIntent: CallbackAction<ProfileIntent>(
                        onInvoke: (intent) => Navigator.of(context)
                            .push(createRoute(const UserProfileScreen())),
                      ),
                    },
                    child: Focus(
                      autofocus: true,
                      child: ScaffoldWrapper(
                        title: "Timeline",
                        body: StreamBuilder<QuerySnapshot>(
                            stream: todoDao.getUndonePastStream(),
                            builder: (context, pastSnapshot) {
                              final bool pastTasksExist =
                                  pastSnapshot.hasData &&
                                      pastSnapshot.data!.docs.isNotEmpty;
                              return pastTasksExist
                                  ? SingleChildScrollView(
                                      physics: const BouncingScrollPhysics(),
                                      controller: scrollController,
                                      child: Column(
                                        children: [
                                          const PastTodoList(
                                              type: TodoItemType.past),
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
        });
  }
}
