import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoaholic/components/todo_item.dart';
import 'package:todoaholic/components/todo_list_header.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/todo.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/todo_item_type.dart';

import '../utils/datetime_extension.dart';

class TodoList extends StatelessWidget {
  final bool pastTasksExist;

  const TodoList({Key? key, required this.pastTasksExist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoDao = Provider.of<TodoDao>(context, listen: false);

    return Consumer<AppState>(builder: (context, appState, child) {
      return StreamBuilder<QuerySnapshot>(
        stream: todoDao.getStream(appState.selectedDate),
        builder: (context, snapshot) {
          final height = MediaQuery.of(context).size.height -
              MediaQuery.of(context).viewPadding.top -
              AppBar().preferredSize.height;

          if (snapshot.hasError) {
            return pastTasksExist || appState.calendarEvents.isNotEmpty
                ? const SizedBox.shrink()
                : const Center(
                    child: Text('Something went wrong...'),
                  );
          }
          if (!snapshot.hasData) {
            return pastTasksExist || appState.calendarEvents.isNotEmpty
                ? const SizedBox.shrink()
                : SizedBox(
                    height: height,
                    child: const Center(child: CircularProgressIndicator()));
          }

          if (snapshot.data!.docs.isEmpty) {
            return pastTasksExist || appState.calendarEvents.isNotEmpty
                ? const SizedBox.shrink()
                : SizedBox(
                    height: height,
                    child: Center(
                      child: Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Nothing for today',
                            style: Theme.of(context).textTheme.headline2,
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              'Add a new task by tapping the + button',
                              style: Theme.of(context).textTheme.bodyText1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          }
          return _buildList(context, snapshot.data!.docs);
        },
      );
    });
  }

  Widget _buildListHeader(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);

    final isToday = appState.selectedDate == DateTime.now().getDateOnly();

    if (isToday) {
      return const TodoListHeader(title: "Today's tasks");
    } else if (appState.calendarEvents.isNotEmpty) {
      return const TodoListHeader(title: "Tasks");
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    final todoDao = Provider.of<TodoDao>(context, listen: false);
    return ReorderableListView(
      onReorder: (int oldIndex, int newIndex) {
        if (oldIndex < newIndex) {
          newIndex -= 1;
        }

        final todoMoved = Todo.fromSnapshot(snapshot.elementAt(oldIndex));
        todoDao.setOrder(todoMoved, newIndex);
      },
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
          bottom: 56 +
              kFloatingActionButtonMargin * 2 +
              MediaQuery.of(context).padding.bottom),
      header: _buildListHeader(context),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final todo = Todo.fromSnapshot(snapshot);
    return TodoItem(
      todo,
      TodoItemType.present,
      key: ObjectKey(todo),
    );
  }
}
