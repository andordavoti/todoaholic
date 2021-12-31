import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoaholic/components/date_navigation_buttons.dart';
import 'package:todoaholic/components/present_todo_list.dart';
import 'package:todoaholic/components/todo_item.dart';
import 'package:todoaholic/components/todo_list_header.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/todo.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/todo_item_type.dart';
import 'package:todoaholic/screens/user_profile_screen.dart';
import 'package:todoaholic/screens/timeline_screen.dart';

import 'manage_todo_screen.dart';
import '../utils/datetime_extension.dart';

class Home extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoDao = Provider.of<TodoDao>(context, listen: false);

    final currentDate = DateTime.now().getDateOnly();

    return Consumer<AppState>(builder: (context, appState, child) {
      return Scaffold(
        body: appState.selectedDate == currentDate
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream:
                          todoDao.getUndonePastStream(appState.selectedDate),
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
                    ),
                    PresentTodoList(noPastTasks: false),
                  ],
                ),
              )
            : PresentTodoList(
                noPastTasks: true,
              ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomLeft,
                child: DateNavigation(
                  leftAction: () {
                    appState.decrementSelectedDate();
                  },
                  leftLongPressAction: () {
                    appState.setSelectedDate(DateTime.now());
                  },
                  rightAction: () {
                    appState.incrementSelectedDate();
                  },
                  rightLongPressAction: () {
                    appState.setSelectedDate(
                        appState.selectedDate.add(const Duration(days: 7)));
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageTodoScreen(null)),
                    );
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: Align(
            alignment: Alignment.topCenter,
            child: InkWell(
                onTap: () async {
                  final currentDate = DateTime.now();

                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: appState.selectedDate,
                    firstDate: DateTime(currentDate.year - 5),
                    lastDate: DateTime(currentDate.year + 5),
                  );

                  if (pickedDate != null) {
                    appState.setSelectedDate(pickedDate);
                  }
                },
                child: Text(DateFormat.yMMMd().format(appState.selectedDate))),
          ),
          leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  icon: Icon(Icons.person_sharp,
                      color: Theme.of(context).textTheme.bodyText2!.color),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserProfileScreen()),
                    );
                  })),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: (IconButton(
                  icon: Icon(Icons.timeline,
                      color: Theme.of(context).textTheme.bodyText2!.color),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TimelineScreen(),
                      ),
                    );
                  })),
            ),
          ],
        ),
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
    return TodoItem(todo, TodoItemType.past);
  }
}
