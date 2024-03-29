import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoaholic/components/todo_item.dart';
import 'package:todoaholic/components/todo_list_header.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/todo.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/todo_item_type.dart';

class TodoList extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final bool noPastTasks;

  TodoList({Key? key, required this.noPastTasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoDao = Provider.of<TodoDao>(context, listen: false);

    return Consumer<AppState>(builder: (context, appState, child) {
      return StreamBuilder<QuerySnapshot>(
        stream: todoDao.getStream(appState.selectedDate),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return noPastTasks
                ? const Center(
                    child: Text('Something went wrong...'),
                  )
                : const SizedBox.shrink();
          }
          if (!snapshot.hasData) {
            return noPastTasks
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink();
          }

          if (snapshot.data!.docs.isEmpty) {
            return noPastTasks
                ? Center(
                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Nothing for today',
                          style: Theme.of(context).textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Add a new task by tapping the + button',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink();
          }
          return _buildList(context, snapshot.data!.docs);
        },
      );
    });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    final todoDao = Provider.of<TodoDao>(context, listen: false);
    return Column(
      children: [
        noPastTasks
            ? const SizedBox.shrink()
            : const TodoListHeader(title: "Today's tasks"),
        Expanded(
          child: ReorderableListView(
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }

              final todoMoved = Todo.fromSnapshot(snapshot.elementAt(oldIndex));
              todoDao.setOrder(todoMoved, newIndex);
            },
            shrinkWrap: true,
            scrollController: _scrollController,
            physics: noPastTasks
                ? const BouncingScrollPhysics()
                : const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
                bottom: 56 +
                    kFloatingActionButtonMargin * 2 +
                    MediaQuery.of(context).padding.bottom),
            children:
                snapshot.map((data) => _buildListItem(context, data)).toList(),
          ),
        ),
      ],
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
