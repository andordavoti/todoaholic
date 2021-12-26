import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'todo.dart';
import '../utils/datetime_extension.dart';

class TodoDao {
  CollectionReference? collection = FirebaseFirestore.instance.collection(
      "users/" + (FirebaseAuth.instance.currentUser!.uid) + "/todos");

  Future<void> saveTodo(Todo todo) async {
    await collection?.add(todo.toJson());
  }

  Future<void> updateTodoText(Todo todo, String newText) async {
    await todo.reference?.update({'text': newText});
  }

  Future<void> updateTodoDone(Todo todo) async {
    await todo.reference?.update({'isDone': true});
  }

  Future<void> updateTodoNotDone(Todo todo) async {
    await todo.reference?.update({'isDone': false});
  }

  Future<void> swipeTomorrow(Todo todo) async {
    DateTime nextDay = todo.date.add(const Duration(days: 1));
    await todo.reference?.update({'date': nextDay.toString()});
  }

  Future<void> removeTodo(Todo todo) async {
    await todo.reference?.delete();
  }

  Stream<QuerySnapshot>? getTodoStream(DateTime selectedDate) {
    return collection
        ?.orderBy('isDone')
        .where('date', isEqualTo: selectedDate.getDateOnly().toString())
        .snapshots();
  }

  // TODO: Implement paging for todo timeline, when the user scrolls to the bottom it should fetch more todos
  Stream<QuerySnapshot>? getTodoTimelineStream() {
    return collection?.orderBy('date', descending: true).limit(200).snapshots();
  }
}
