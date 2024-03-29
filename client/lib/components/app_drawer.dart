import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/components/manage_custom_list_dialog.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/custom_list.dart';
import 'package:todoaholic/data/lists_dao.dart';
import 'package:todoaholic/screens/home.dart';
import 'package:todoaholic/screens/timeline_screen.dart';
import 'package:todoaholic/utils/create_route.dart';
import '../screens/custom_list_screen.dart';
import '../screens/user_profile_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final displayName = FirebaseAuth.instance.currentUser!.displayName;

    getFirstName() {
      if (displayName != null) {
        List<String> wordList = displayName.split(" ");
        return wordList[0];
      } else {
        return '';
      }
    }

    getGreeting() {
      final currentHour = DateTime.now().hour;
      if (currentHour < 12) {
        return 'Good morning${getFirstName().isNotEmpty ? ', ${getFirstName()}!' : '!'}';
      } else if (currentHour < 18) {
        return 'Good afternoon${getFirstName().isNotEmpty ? ', ${getFirstName()}!' : '!'}';
      } else {
        return 'Good evening${getFirstName().isNotEmpty ? ', ${getFirstName()}!' : '!'}';
      }
    }

    return Drawer(
      width: 300,
      backgroundColor: Theme.of(context).primaryColor,
      child: Consumer<AppState>(builder: (context, appState, child) {
        return ListView(
          primary: true,
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  const UserAvatar(
                    size: 81,
                  ),
                  ListTile(
                    title: Text(
                      getGreeting(),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.task_alt,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
              title: Text(
                'Tasks',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).push(createRoute(Home()));
              },
            ),
            ListTile(
              leading: Icon(Icons.timeline,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
              title: Text(
                'Timeline',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).push(createRoute(const TimelineScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.person_sharp,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
              title: Text(
                'Profile',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context)
                    .push(createRoute(const UserProfileScreen()));
              },
            ),
            const Divider(),
            ListTile(
              title: Text(
                'Your lists',
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            _buildList(context),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              child: ListTile(
                  leading: Icon(Icons.add,
                      color: Theme.of(context).textTheme.bodyMedium!.color),
                  title: Text('Add a new list',
                      style: Theme.of(context).textTheme.bodyMedium),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const ManageCustomListDialog(editList: null);
                        });
                  }),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildList(BuildContext context) {
    final listsDao = Provider.of<ListsDao>(context, listen: false);
    return StreamBuilder<QuerySnapshot>(
        stream: listsDao.getStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ListTile(
              title: Text('Something went wrong...',
                  style: Theme.of(context).textTheme.bodyMedium),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const SizedBox.shrink();
          }

          final docs = snapshot.data!.docs;
          return Flex(direction: Axis.horizontal, children: [
            Expanded(
              child: ReorderableListView(
                onReorder: (int oldIndex, int newIndex) {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }

                  final listMoved =
                      CustomList.fromSnapshot(docs.elementAt(oldIndex));
                  listsDao.setOrder(listMoved, newIndex);
                },
                shrinkWrap: true,
                primary: false,
                children:
                    docs.map((data) => _buildListItem(context, data)).toList(),
              ),
            ),
          ]);
        });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot snapshot) {
    final appState = Provider.of<AppState>(context, listen: false);
    final list = CustomList.fromSnapshot(snapshot);
    return Dismissible(
      key: ObjectKey(list),
      direction: DismissDirection.endToStart,
      confirmDismiss: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
          HapticFeedback.mediumImpact();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ManageCustomListDialog(editList: list);
              });
          return Future<bool?>.value(false);
        }
        return Future<bool?>.value(true);
      },
      background: Container(
        color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(Icons.edit,
                    color: Theme.of(context)
                        .floatingActionButtonTheme
                        .foregroundColor),
              )),
        ),
      ),
      child: ListTile(
          key: ObjectKey(list),
          title: Text(list.name, style: Theme.of(context).textTheme.bodyMedium),
          onTap: () {
            appState.setSelectedList(list);
            HapticFeedback.selectionClick();
            Navigator.of(context).push(createRoute(const CustomListScreen()));
          }),
    );
  }
}
