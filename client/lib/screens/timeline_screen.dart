import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/components/todo_item.dart';
import 'package:todoaholic/components/todo_list_header.dart';
import 'package:todoaholic/data/todo.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:todoaholic/data/todo_item_type.dart';

import '../utils/timestamp_converter.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        stream: todoDao.getTimelineStream(),
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
            );
          }
          return _buildList(context, snapshot.data!.docs);
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return GroupedListView<Todo, String>(
      elements: snapshot!.map((doc) => Todo.fromSnapshot(doc)).toList(),
      groupBy: (element) => element.date.toString(),
      groupSeparatorBuilder: (groupByValue) => TodoListHeader(
          title: DateFormat.yMMMd()
              .format((TimestampConverter.parseString(groupByValue)).toDate())),
      itemBuilder: (context, element) => _buildListItem(context, element),
    );
  }

  Widget _buildListItem(BuildContext context, Todo element) {
    return TodoItem(element, TodoItemType.timeline);
  }
}
