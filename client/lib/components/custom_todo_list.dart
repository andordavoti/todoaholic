import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoaholic/components/todo_item.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/custom_list_dao.dart';
import 'package:todoaholic/data/todo.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/todo_item_type.dart';

class CustomTodoList extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  CustomTodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customListDao = Provider.of<CustomListDao>(context, listen: false);

    return Consumer<AppState>(builder: (context, appState, child) {
      if (appState.selectedList != null) {
        return StreamBuilder<QuerySnapshot>(
          stream: customListDao.getStream(appState.selectedList!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Something went wrong...'),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Nothing in this list',
                      style: Theme.of(context).textTheme.headline2,
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Add something by tapping the + button',
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }
            return _buildList(context, snapshot.data!.docs);
          },
        );
      } else {
        return Center(
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No list selected',
                style: Theme.of(context).textTheme.headline2,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Please select a list from the drawer',
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      }
    });
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
      scrollController: _scrollController,
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
          bottom: 56 +
              kFloatingActionButtonMargin * 2 +
              MediaQuery.of(context).padding.bottom),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final todo = Todo.fromSnapshot(snapshot);
    return TodoItem(
      todo,
      TodoItemType.custom,
      key: ObjectKey(todo),
    );
  }
}
