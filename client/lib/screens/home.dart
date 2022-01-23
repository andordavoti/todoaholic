import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:todoaholic/components/app_drawer.dart';
import 'package:todoaholic/components/date_navigation_buttons.dart';
import 'package:todoaholic/components/past_todo_list.dart';
import 'package:todoaholic/components/todo_list.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:todoaholic/data/todo_item_type.dart';
import 'package:todoaholic/screens/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_screen.dart';
import 'manage_todo_screen.dart';
import '../utils/datetime_extension.dart';

class PrevDayIntent extends Intent {}

class CurrentDayIntent extends Intent {}

class NextDayIntent extends Intent {}

class TimelineIntent extends Intent {}

class ProfileIntent extends Intent {}

class AddTaskIntent extends Intent {}

class Home extends StatelessWidget {
  static const String routeName = '/home';

  final ScrollController _scrollController = ScrollController();

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now().getDateOnly();
    final todoDao = Provider.of<TodoDao>(context, listen: false);

    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const AuthScreen()
              : Consumer<AppState>(builder: (context, appState, child) {
                  void prevDay() => appState.decrementSelectedDate();
                  void currentDay() => appState.setSelectedDate(DateTime.now());
                  void nextDay() => appState.incrementSelectedDate();
                  void oneWeekForward() => appState.setSelectedDate(
                      appState.selectedDate.add(const Duration(days: 7)));

                  return Shortcuts(
                    shortcuts: {
                      LogicalKeySet(LogicalKeyboardKey.arrowLeft):
                          PrevDayIntent(),
                      LogicalKeySet(LogicalKeyboardKey.arrowDown):
                          CurrentDayIntent(),
                      LogicalKeySet(LogicalKeyboardKey.arrowRight):
                          NextDayIntent(),
                      LogicalKeySet(LogicalKeyboardKey.keyT): TimelineIntent(),
                      LogicalKeySet(LogicalKeyboardKey.keyP): ProfileIntent(),
                      LogicalKeySet(LogicalKeyboardKey.keyA): AddTaskIntent(),
                      LogicalKeySet(LogicalKeyboardKey.add): AddTaskIntent(),
                    },
                    child: Actions(
                      actions: {
                        PrevDayIntent: CallbackAction<PrevDayIntent>(
                            onInvoke: (intent) => prevDay()),
                        CurrentDayIntent: CallbackAction<CurrentDayIntent>(
                            onInvoke: (intent) => currentDay()),
                        NextDayIntent: CallbackAction<NextDayIntent>(
                            onInvoke: (intent) => nextDay()),
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
                                              null, TodoItemType.present)),
                                )),
                      },
                      child: Focus(
                        autofocus: true,
                        child: Scaffold(
                          drawer: const AppDrawer(),
                          body: StreamBuilder<QuerySnapshot>(
                              stream: todoDao.getUndonePastStream(),
                              builder: (context, pastSnapshot) {
                                final bool pastTasksExist =
                                    pastSnapshot.hasData &&
                                        pastSnapshot.data!.docs.isNotEmpty;

                                return appState.selectedDate == currentDate &&
                                        pastTasksExist
                                    ? SingleChildScrollView(
                                        physics: const BouncingScrollPhysics(),
                                        controller: _scrollController,
                                        child: Column(
                                          children: [
                                            const PastTodoList(
                                                type: TodoItemType.past),
                                            TodoList(noPastTasks: false),
                                          ],
                                        ),
                                      )
                                    : TodoList(
                                        noPastTasks: true,
                                      );
                              }),
                          resizeToAvoidBottomInset: false,
                          floatingActionButton: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: DateNavigation(
                                    leftAction: prevDay,
                                    leftLongPressAction: currentDay,
                                    rightAction: nextDay,
                                    rightLongPressAction: oneWeekForward,
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
                                            builder: (context) =>
                                                const ManageTodoScreen(null,
                                                    TodoItemType.present)),
                                      );
                                    },
                                    child: const Icon(Icons.add),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          floatingActionButtonLocation:
                              FloatingActionButtonLocation.centerFloat,
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
                                  child: Text(DateFormat('EEEE, MMMM d')
                                      .format(appState.selectedDate))),
                            ),
                            actions: const [
                              IconButton(
                                color: Colors.transparent,
                                icon: SizedBox.shrink(),
                                onPressed: null,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
        });
  }
}
