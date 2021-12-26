import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/app_state_provider.dart';
import 'package:todoaholic/data/todo_dao.dart';
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

  @override
  void initState() {
    super.initState();
    _textController.text = widget.originalTodo?.text ?? '';

    SchedulerBinding.instance!.addPostFrameCallback(
        (_) => {FocusScope.of(context).requestFocus(textFocusNode)});
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoDao = Provider.of<TodoDao>(context, listen: false);

    void submitAction(DateTime selectedDate) {
      final originalTodo = widget.originalTodo;
      if (originalTodo != null) {
        todoDao.updateTodoText(originalTodo, _textController.text);
      } else {
        todoDao.saveTodo(Todo(
            text: _textController.text, date: selectedDate, isDone: false));
      }

      Navigator.pop(context);
    }

    return Consumer<AppState>(builder: (context, appState, child) {
      return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                submitAction(appState.selectedDate);
              },
            )
          ],
          title: Text(
            widget.originalTodo == null ? 'Add Todo' : 'Edit Todo',
          ),
        ),
        // 5
        body: Container(
          padding: const EdgeInsets.all(16),
          child: TextField(
            focusNode: textFocusNode,
            controller: _textController,
            onSubmitted: (_) {
              submitAction(appState.selectedDate);
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter todo text',
            ),
          ),
        ),
      );
    });
  }
}
