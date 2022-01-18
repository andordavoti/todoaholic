import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/custom_list_dao.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:todoaholic/data/todo_item_type.dart';

import '../data/todo.dart';
import '../utils/datetime_extension.dart';

class BackIntent extends Intent {}

class ManageTodoScreen extends StatefulWidget {
  final Todo? originalTodo;
  final TodoItemType type;

  const ManageTodoScreen(
    this.originalTodo,
    this.type, {
    Key? key,
  }) : super(key: key);

  @override
  _ManageTodoScreenState createState() => _ManageTodoScreenState();
}

class _ManageTodoScreenState extends State<ManageTodoScreen> {
  final _textController = TextEditingController();
  final textFocusNode = FocusNode();
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    _textController.text = widget.originalTodo?.text ?? '';

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final appState = Provider.of<AppState>(context, listen: false);

      setState(() {
        selectedDate =
            widget.originalTodo?.date.toDate() ?? appState.selectedDate;
      });

      SchedulerBinding.instance!.addPostFrameCallback(
          (_) => {FocusScope.of(context).requestFocus(textFocusNode)});
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final todoDao = Provider.of<TodoDao>(context, listen: false);

    void submitAction(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) async {
      HapticFeedback.heavyImpact();
      final list = appState.selectedList;
      final originalTodo = widget.originalTodo;
      final text = _textController.text;

      // If it's a custom list
      if (list != null && widget.type == TodoItemType.custom) {
        final customListDao =
            Provider.of<CustomListDao>(context, listen: false);

        if (originalTodo != null) {
          if (text.isEmpty) {
            customListDao.remove(originalTodo);
          }
          if (selectedDate != null) {
            customListDao.update(originalTodo, text, selectedDate!);
          }
        } else if (text.isNotEmpty && selectedDate != null) {
          customListDao.save(
              list,
              Todo(
                text: text,
                date: Timestamp.fromDate(selectedDate!),
                isDone: false,
                order: 0,
              ));
        }
      } else {
        // If it's the regular list
        if (originalTodo != null) {
          if (text.isEmpty) {
            todoDao.remove(originalTodo);
          }
          if (selectedDate != null) {
            todoDao.update(originalTodo, text, selectedDate!);
          }
        } else if (text.isNotEmpty && selectedDate != null) {
          todoDao.save(Todo(
            text: text,
            date: Timestamp.fromDate(selectedDate!),
            isDone: false,
            order: snapshot.data!.docs.length,
          ));
        }
      }
      Navigator.pop(context);
    }

    return StreamBuilder<QuerySnapshot>(
        stream: todoDao.getStream(selectedDate ?? DateTime.now().getDateOnly()),
        builder: (context, snapshot) {
          return Shortcuts(
            shortcuts: {
              LogicalKeySet(LogicalKeyboardKey.escape): BackIntent(),
            },
            child: Actions(
              actions: {
                BackIntent: CallbackAction<BackIntent>(
                    onInvoke: (intent) => Navigator.pop(context)),
              },
              child: Focus(
                autofocus: true,
                child: Scaffold(
                  appBar: AppBar(
                    leading: BackButton(onPressed: () {
                      HapticFeedback.selectionClick();
                      Navigator.pop(context);
                    }),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.check),
                        onPressed: () {
                          submitAction(snapshot);
                        },
                      )
                    ],
                    title: Text(
                      widget.originalTodo == null ? 'Add Task' : 'Edit Task',
                    ),
                  ),
                  body: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: TextField(
                          focusNode: textFocusNode,
                          controller: _textController,
                          onSubmitted: (_) {
                            submitAction(snapshot);
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter task here',
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 25, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectedDate != null
                                    ? DateFormat('EEEE, MMMM d')
                                        .format(selectedDate!)
                                    : '',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              IconButton(
                                  icon: const Icon(Icons.date_range),
                                  onPressed: () async {
                                    if (selectedDate != null) {
                                      final currentDate = DateTime.now();

                                      final pickedDate = await showDatePicker(
                                        context: context,
                                        initialDate: selectedDate!,
                                        firstDate:
                                            DateTime(currentDate.year - 5),
                                        lastDate:
                                            DateTime(currentDate.year + 5),
                                      );

                                      if (pickedDate != null) {
                                        setState(() {
                                          selectedDate = pickedDate;
                                        });
                                      }
                                    }
                                  }),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
