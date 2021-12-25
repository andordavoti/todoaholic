import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoaholic/components/date_navigation_buttons.dart';
import 'package:todoaholic/components/todo_item.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/todo.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/user_dao.dart';

import '../utils/datetime_extension.dart';

class Home extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoDao = Provider.of<TodoDao>(context, listen: false);
    final userDao = Provider.of<UserDao>(context, listen: false);
    final photoURL = userDao.photoURL();

    return Consumer<AppState>(builder: (context, appState, child) {
      return Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: todoDao.getTodoStream(appState.selectedDate),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(
                child: Text('Something went wrong...'),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            // TODO: show empty state
            if (snapshot.data!.docs.isEmpty) {
              return Container(
                color: Colors.red,
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
                  rightAction: () {
                    appState.incrementSelectedDate();
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () {
                    todoDao.saveTodo(Todo(
                        text: 'test',
                        date: appState.selectedDate.getDateOnly(),
                        isDone: false));
                  },
                  child: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: AppBar(
          title: InkWell(
              onTap: () async {
                final currentDate = DateTime.now();

                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: appState.selectedDate,
                  firstDate: currentDate.isBefore(appState.selectedDate)
                      ? currentDate
                      : appState.selectedDate,
                  lastDate: DateTime(currentDate.year + 5),
                );

                if (selectedDate != null) {
                  appState.setSelectedDate(selectedDate);
                }
              },
              child: Text(DateFormat.yMMMd().format(appState.selectedDate))),
          actions: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  child: photoURL == null
                      ? (CircleAvatar(
                          child: Icon(Icons.person,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color),
                          backgroundColor:
                              Theme.of(context).secondaryHeaderColor,
                          radius: 18,
                        ))
                      : CircleAvatar(
                          backgroundImage: NetworkImage(photoURL),
                        ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                          providerConfigs: const [EmailProviderConfiguration()],
                          avatarSize: 100,
                          actions: [
                            SignedOutAction((context) {
                              Navigator.of(context).pop();
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ))
          ],
        ),
      );
    });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot>? snapshot) {
    return ListView.separated(
      padding: EdgeInsets.only(
          bottom: 56 +
              kFloatingActionButtonMargin * 2 +
              MediaQuery.of(context).padding.bottom),
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      itemCount: snapshot!.length,
      separatorBuilder: (BuildContext context, int index) =>
          const Divider(height: 1),
      itemBuilder: (BuildContext context, int index) {
        return _buildListItem(context, snapshot[index]);
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final todo = Todo.fromSnapshot(snapshot);
    return TodoItem(todo);
  }
}