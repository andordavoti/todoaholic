import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoaholic/components/date_navigation_buttons.dart';
import 'package:todoaholic/components/todo_item.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/todo.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/screens/user_profile_screen.dart';
import 'package:todoaholic/screens/timeline_screen.dart';
import 'package:async/async.dart';

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
        body: StreamBuilder<QuerySnapshot>(
          stream: appState.selectedDate == currentDate
              ? StreamGroup.merge([
                  todoDao.getTodoPresentStream(appState.selectedDate),
                  todoDao.getTodoRelevantPastStream(appState.selectedDate),
                ])
              : todoDao.getTodoPresentStream(appState.selectedDate),
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
              );
            }
            return _buildList(context, snapshot.data!.docs);
          },
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

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return ListView(
      padding: EdgeInsets.only(
          bottom: 56 +
              kFloatingActionButtonMargin * 2 +
              MediaQuery.of(context).padding.bottom),
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      children: snapshot!.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final todo = Todo.fromSnapshot(snapshot);
    return TodoItem(todo, false);
  }
}
