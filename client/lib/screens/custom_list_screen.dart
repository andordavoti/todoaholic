import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/components/app_drawer.dart';
import 'package:todoaholic/components/custom_todo_list.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/todo_item_type.dart';

import 'manage_todo_screen.dart';

class AddTaskIntent extends Intent {}

class BackIntent extends Intent {}

class CustomListScreen extends StatelessWidget {
  static const String routeName = '/customList';

  const CustomListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.keyA): AddTaskIntent(),
          LogicalKeySet(LogicalKeyboardKey.add): AddTaskIntent(),
          LogicalKeySet(LogicalKeyboardKey.escape): BackIntent(),
        },
        child: Actions(
          actions: {
            AddTaskIntent: CallbackAction<AddTaskIntent>(
                onInvoke: (intent) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageTodoScreen(
                              null, TodoItemType.custom)),
                    )),
            BackIntent: CallbackAction<BackIntent>(
                onInvoke: (intent) => Navigator.pop(context)),
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
                      child: Text(appState.selectedList?.name ?? "")),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    if (appState.selectedList != null) {
                      HapticFeedback.selectionClick();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ManageTodoScreen(
                                null, TodoItemType.custom)),
                      );
                    }
                  },
                  child: const Icon(Icons.add),
                ),
                body: CustomTodoList()),
          ),
        ),
      );
    });
  }
}
