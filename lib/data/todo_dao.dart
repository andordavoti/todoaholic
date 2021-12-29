import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'todo.dart';

class TodoDao {
  CollectionReference? collection = FirebaseFirestore.instance.collection(
      "users/" + (FirebaseAuth.instance.currentUser!.uid) + "/todos");

  Future<void> saveTodo(Todo todo) async {
    await collection?.add(todo.toJson());
  }

  Future<void> updateTodo(Todo todo, String newText, DateTime newDate) async {
    await todo.reference
        ?.update({'text': newText, 'date': Timestamp.fromDate(newDate)});
  }

  Future<void> updateTodoDone(Todo todo) async {
    await todo.reference?.update({'isDone': true});
  }

  Future<void> updateTodoNotDone(Todo todo) async {
    await todo.reference?.update({'isDone': false});
  }

  Future<void> swipeTomorrow(Todo todo) async {
    DateTime nextDay = todo.date.toDate().add(const Duration(days: 1));
    await todo.reference?.update({'date': Timestamp.fromDate(nextDay)});
  }

  Future<void> removeTodo(Todo todo) async {
    await todo.reference?.delete();
  }

  Stream<QuerySnapshot>? getTodoStream(DateTime selectedDate) {
    return collection
        ?.orderBy('isDone')
        .where('date', isEqualTo: Timestamp.fromDate(selectedDate))
        .snapshots();
  }

  Stream<QuerySnapshot>? getTodoTimelineStream() {
    return collection
        ?.where('date', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('date')
        .orderBy('isDone')
        .limit(200)
        .snapshots();
  }
}
