import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String text;
  final bool isDone;
  final Timestamp date;
  DocumentReference? reference;

  Todo({
    required this.text,
    required this.isDone,
    required this.date,
    this.reference,
  });

  factory Todo.fromJson(Map<dynamic, dynamic> json) => Todo(
        text: json['text'] as String,
        isDone: json['isDone'] as bool,
        date: (json['date'] as Timestamp),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'date': date,
        'isDone': isDone,
        'text': text,
      };

  factory Todo.fromSnapshot(DocumentSnapshot snapshot) {
    final todo = Todo.fromJson(snapshot.data() as Map<String, dynamic>);
    todo.reference = snapshot.reference;
    return todo;
  }
}
