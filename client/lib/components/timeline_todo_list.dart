import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:todoaholic/components/todo_item.dart';
import 'package:todoaholic/components/todo_list_header.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/todo.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/todo_item_type.dart';
import 'package:intl/intl.dart';
import 'package:todoaholic/utils/timestamp_converter.dart';

class TimelineTodoList extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final bool noPastTasks;

  TimelineTodoList({Key? key, required this.noPastTasks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoDao = Provider.of<TodoDao>(context, listen: false);

    return Consumer<AppState>(builder: (context, appState, child) {
      return StreamBuilder<QuerySnapshot>(
        stream: todoDao.getTimelineStream(),
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
                          'Nothing to do...',
                          style: Theme.of(context).textTheme.headline2,
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Go back and add some tasks',
                            style: Theme.of(context).textTheme.bodyText1,
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

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return GroupedListView<Todo, String>(
      shrinkWrap: true,
      physics: noPastTasks
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      controller: _scrollController,
      elements: snapshot!.map((doc) => Todo.fromSnapshot(doc)).toList(),
      groupBy: (element) => element.date.toString(),
      groupSeparatorBuilder: (groupByValue) => TodoListHeader(
          title: DateFormat('EEEE, MMMM d')
              .format((TimestampConverter.parseString(groupByValue)).toDate())),
      itemBuilder: (context, element) => _buildListItem(context, element),
    );
  }

  Widget _buildListItem(BuildContext context, Todo element) {
    return TodoItem(element, TodoItemType.timeline);
  }
}
