import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../data/todo.dart';
import '../utils/datetime_extension.dart';

class ManageTodoScreen extends StatefulWidget {
  final Todo? originalTodo;

  const ManageTodoScreen(
    this.originalTodo, {
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
    final todoDao = Provider.of<TodoDao>(context, listen: false);

    void submitAction(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
      HapticFeedback.heavyImpact();
      final originalTodo = widget.originalTodo;
      final text = _textController.text;

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

      Navigator.pop(context);
    }

    return StreamBuilder<QuerySnapshot>(
        stream: todoDao.getStream(selectedDate ?? DateTime.now().getDateOnly()),
        builder: (context, snapshot) {
          return Scaffold(
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
                Container(
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
                Container(
                    padding: const EdgeInsets.only(left: 25, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedDate != null
                              ? DateFormat.yMMMd().format(selectedDate!)
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
                                  firstDate: DateTime(currentDate.year - 5),
                                  lastDate: DateTime(currentDate.year + 5),
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
          );
        });
  }
}
