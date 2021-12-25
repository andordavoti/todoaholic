import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:todoaholic/data/todo_dao.dart';
import '../data/todo.dart';

class EditTodoScreen extends StatefulWidget {
  final Todo originalTodo;

  const EditTodoScreen(
    this.originalTodo, {
    Key? key,
  }) : super(key: key);

  @override
  _EditTodoScreenState createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final _textController = TextEditingController();
  final textFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final originalItem = widget.originalTodo;
    _textController.text = originalItem.text;

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

    void submitAction() {
      todoDao.updateTodoText(widget.originalTodo, _textController.text);
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
        title: const Text(
          'Edit Todo',
        ),
      ),
      // 5
      body: Container(
        padding: EdgeInsets.all(16),
        child: TextField(
          focusNode: textFocusNode,
          controller: _textController,
          onSubmitted: (_) {
            submitAction();
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter todo text',
          ),
        ),
      ),
    );
  }
}
