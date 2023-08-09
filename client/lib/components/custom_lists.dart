import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/lists_dao.dart';
import 'package:todoaholic/data/custom_list.dart';
import 'package:todoaholic/screens/routes.dart';

import 'manage_custom_list_dialog.dart';

class CustomLists extends StatelessWidget {
  const CustomLists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }
          final docs = snapshot.data?.docs;

          if (docs == null) {
            return const SizedBox.shrink();
          }
          if (docs.isEmpty) {
            return const SizedBox.shrink();
          }
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
            Navigator.pushReplacementNamed(context, Routes.customList);
          }),
    );
  }
}
