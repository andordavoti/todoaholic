import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/components/app_drawer.dart';
import 'package:todoaholic/components/custom_todo_list.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/todo_item_type.dart';
import 'package:todoaholic/screens/routes.dart';

import 'auth_screen.dart';
import 'manage_todo_screen.dart';

class TasksIntent extends Intent {}

class TimelineIntent extends Intent {}

class ProfileIntent extends Intent {}

class AddTaskIntent extends Intent {}

class BackIntent extends Intent {}

class CustomListScreen extends StatelessWidget {
  static const String routeName = '/customList';

  const CustomListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const AuthScreen()
              : Consumer<AppState>(builder: (context, appState, child) {
                  return Shortcuts(
                    shortcuts: {
                      LogicalKeySet(LogicalKeyboardKey.keyH): TasksIntent(),
                      LogicalKeySet(LogicalKeyboardKey.keyT): TimelineIntent(),
                      LogicalKeySet(LogicalKeyboardKey.keyP): ProfileIntent(),
                      LogicalKeySet(LogicalKeyboardKey.keyA): AddTaskIntent(),
                      LogicalKeySet(LogicalKeyboardKey.add): AddTaskIntent(),
                      LogicalKeySet(LogicalKeyboardKey.escape): BackIntent(),
                    },
                    child: Actions(
                      actions: {
                        TasksIntent: CallbackAction<TasksIntent>(
                            onInvoke: (intent) =>
                                Navigator.pushReplacementNamed(
                                    context, Routes.home)),
                        TimelineIntent: CallbackAction<TimelineIntent>(
                            onInvoke: (intent) =>
                                Navigator.pushReplacementNamed(
                                    context, Routes.timeline)),
                        ProfileIntent: CallbackAction<ProfileIntent>(
                            onInvoke: (intent) =>
                                Navigator.pushReplacementNamed(
                                    context, Routes.profile)),
                        AddTaskIntent: CallbackAction<AddTaskIntent>(
                            onInvoke: (intent) => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ManageTodoScreen(
                                              null, TodoItemType.custom)),
                                )),
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
                              title: Align(
                                  alignment: Alignment.topCenter,
                                  child: Text(appState.selectedList?.name ??
                                      "No list selected")),
                            ),
                            floatingActionButton: FloatingActionButton(
                              onPressed: () {
                                if (appState.selectedList != null) {
                                  HapticFeedback.selectionClick();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ManageTodoScreen(
                                                null, TodoItemType.custom)),
                                  );
                                }
                              },
                              child: const Icon(Icons.add),
                            ),
                            body: const CustomTodoList()),
                      ),
                    ),
                  );
                });
        });
  }
}
