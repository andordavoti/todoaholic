import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  final String text;
  final bool isDone;
  final Timestamp date;
  int? order;
  DocumentReference? reference;

  Todo({
    required this.text,
    required this.isDone,
    required this.date,
    required this.order,
    this.reference,
  });

  factory Todo.fromJson(Map<dynamic, dynamic> json) => Todo(
        text: json['text'] as String,
        isDone: json['isDone'] as bool,
        date: (json['date'] as Timestamp),
        order: (json['order'] as int?),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'text': text,
        'isDone': isDone,
        'date': date,
        'order': order,
      };

  factory Todo.fromSnapshot(DocumentSnapshot snapshot) {
    final todo = Todo.fromJson(snapshot.data() as Map<String, dynamic>);
    todo.reference = snapshot.reference;
    return todo;
  }
}
