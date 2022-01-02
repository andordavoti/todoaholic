import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoaholic/components/todo_item.dart';
import 'package:todoaholic/components/todo_list_header.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/todo.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/todo_item_type.dart';

class PastTodoList extends StatelessWidget {
  final TodoItemType type;

  const PastTodoList({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoDao = Provider.of<TodoDao>(context, listen: false);

    return Consumer<AppState>(builder: (context, appState, child) {
      return StreamBuilder<QuerySnapshot>(
        stream: todoDao.getUndonePastStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SizedBox.shrink();
          }
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          if (snapshot.data!.docs.isEmpty) {
            return const SizedBox.shrink();
          }
          return _buildPastList(context, snapshot.data!.docs);
        },
      );
    });
  }

  Widget _buildPastList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Column(
      children: [
        const TodoListHeader(title: 'Past undone tasks'),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children:
              snapshot.map((data) => _buildListItem(context, data)).toList(),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final todo = Todo.fromSnapshot(snapshot);
    return TodoItem(todo, type);
  }
}
