import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'todo.dart';
import '../utils/datetime_extension.dart';

class TodoDao {
  CollectionReference? collection = FirebaseFirestore.instance.collection(
      "users/" + (FirebaseAuth.instance.currentUser!.uid) + "/todos");

  void saveTodo(Todo todo) {
    collection?.add(todo.toJson());
  }

  void updateTodoText(Todo todo, String newText) {
    todo.reference?.update({'text': newText});
  }

  void updateTodoDone(Todo todo) {
    todo.reference?.update({'isDone': true});
  }

  void updateTodoNotDone(Todo todo) {
    todo.reference?.update({'isDone': false});
  }

  void swipeTomorrow(Todo todo) {
    DateTime nextDay = todo.date.add(const Duration(days: 1));
    todo.reference?.update({'date': nextDay.toString()});
  }

  void removeTodo(Todo todo) {
    todo.reference?.delete();
  }

  Stream<QuerySnapshot>? getTodoStream(DateTime selectedDate) {
    return collection
        ?.where('date', isEqualTo: selectedDate.getDateOnly().toString())
        .snapshots();
  }

  // TODO: Implement paging for todo timeline, when the user scrolls to the bottom it should fetch more todos
  Stream<QuerySnapshot>? getTodoTimelineStream() {
    return collection?.orderBy('date', descending: true).limit(200).snapshots();
  }
}
