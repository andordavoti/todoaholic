import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/todo.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:todoaholic/screens/manage_todo_screen.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem(
    this.todo, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todoDao = Provider.of<TodoDao>(context, listen: false);
    return Column(
      children: [
        Dismissible(
          key: ObjectKey(todo),
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart && todo.isDone) {
              HapticFeedback.mediumImpact();
              todoDao.removeTodo(todo);
            }
            if (direction == DismissDirection.startToEnd) {
              HapticFeedback.mediumImpact();
              todoDao.swipeTomorrow(todo);
            }
          },
          confirmDismiss: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart && !todo.isDone) {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManageTodoScreen(todo),
                ),
              );
              return Future<bool?>.value(false);
            }
            return Future<bool?>.value(true);
          },
          secondaryBackground: Container(
            color: todo.isDone
                ? Colors.red
                : Theme.of(context).floatingActionButtonTheme.backgroundColor,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(
                  todo.isDone ? Icons.delete : Icons.edit,
                  color: todo.isDone
                      ? Theme.of(context)
                          .floatingActionButtonTheme
                          .backgroundColor
                      : Theme.of(context)
                          .floatingActionButtonTheme
                          .foregroundColor,
                ),
              ),
            ),
          ),
          background: Container(
            color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(children: [
                  Text('Tommorrow',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Theme.of(context)
                              .floatingActionButtonTheme
                              .foregroundColor)),
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.chevron_right,
                      color: Theme.of(context)
                          .floatingActionButtonTheme
                          .foregroundColor,
                    ),
                  ),
                ]),
              ),
            ),
          ),
          child: InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              if (todo.isDone) {
                todoDao.updateTodoNotDone(todo);
              } else {
                todoDao.updateTodoDone(todo);
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text(
                    todo.text,
                    style: todo.isDone
                        ? Theme.of(context)
                            .textTheme
                            .bodyText2!
                            .copyWith(decoration: TextDecoration.lineThrough)
                        : Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(height: 1)
      ],
    );
  }
}
