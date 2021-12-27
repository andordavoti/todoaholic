import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/todo_dao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../data/todo.dart';

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
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    _textController.text = widget.originalTodo?.text ?? '';

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      final appState = Provider.of<AppState>(context, listen: false);

      SchedulerBinding.instance!.addPostFrameCallback(
          (_) => {FocusScope.of(context).requestFocus(textFocusNode)});

      setState(() {
        selectedDate =
            widget.originalTodo?.date.toDate() ?? appState.selectedDate;
      });
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

    void submitAction() {
      final originalTodo = widget.originalTodo;
      if (originalTodo != null) {
        todoDao.updateTodo(originalTodo, _textController.text, selectedDate);
      } else {
        todoDao.saveTodo(Todo(
            text: _textController.text,
            date: Timestamp.fromDate(selectedDate),
            isDone: false));
      }

      Navigator.pop(context);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: submitAction,
          )
        ],
        title: Text(
          widget.originalTodo == null ? 'Add Task' : 'Edit Task',
        ),
      ),
      // 5
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              focusNode: textFocusNode,
              controller: _textController,
              onSubmitted: (_) {
                submitAction();
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
                    DateFormat.yMMMd().format(selectedDate),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  IconButton(
                      icon: const Icon(Icons.date_range),
                      onPressed: () async {
                        final currentDate = DateTime.now();

                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(currentDate.year - 5),
                          lastDate: DateTime(currentDate.year + 5),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      }),
                ],
              )),
        ],
      ),
    );
  }
}
