import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/datetime_extension.dart';
import 'todo.dart';

class TodoDao {
  Future<void> save(Todo todo) async {
    CollectionReference collection = FirebaseFirestore.instance.collection(
        "users/" + (FirebaseAuth.instance.currentUser!.uid) + "/todos");

    await collection.add(todo.toJson());
  }

  Future<void> update(Todo todo, String newText, DateTime newDate) async {
    await todo.reference
        ?.update({'text': newText, 'date': Timestamp.fromDate(newDate)});
  }

  Future<void> setOrder(Todo todo, int order) async {
    await todo.reference?.update({'order': order});
  }

  Future<void> setDone(Todo todo) async {
    await todo.reference?.update({'isDone': true});
  }

  Future<void> setNotDone(Todo todo) async {
    await todo.reference?.update({'isDone': false});
  }

  Future<void> swipeTomorrow(Todo todo) async {
    DateTime nextDay = todo.date.toDate().add(const Duration(days: 1));
    await todo.reference
        ?.update({'date': Timestamp.fromDate(nextDay), 'order': 0});
  }

  Future<void> moveToToday(Todo todo) async {
    final currentDate = DateTime.now().getDateOnly();
    await todo.reference
        ?.update({'date': Timestamp.fromDate(currentDate), 'order': 0});
  }

  Future<void> remove(Todo todo) async {
    await todo.reference?.delete();
  }

  Stream<QuerySnapshot> getStream(DateTime selectedDate) {
    CollectionReference collection = FirebaseFirestore.instance.collection(
        "users/" + (FirebaseAuth.instance.currentUser!.uid) + "/todos");

    final currentDate = DateTime.now().getDateOnly();

    if (selectedDate.isBefore(currentDate)) {
      return collection
          .where('date', isEqualTo: Timestamp.fromDate(selectedDate))
          .where('isDone', isEqualTo: true)
          .orderBy('order')
          .snapshots();
    } else {
      return collection
          .where('date', isEqualTo: Timestamp.fromDate(selectedDate))
          .orderBy('isDone')
          .orderBy('order')
          .snapshots();
    }
  }

  Stream<QuerySnapshot> getUndonePastStream() {
    CollectionReference collection = FirebaseFirestore.instance.collection(
        "users/" + (FirebaseAuth.instance.currentUser!.uid) + "/todos");

    return collection
        .where('isDone', isEqualTo: false)
        .where('date',
            isLessThan: Timestamp.fromDate(DateTime.now().getDateOnly()))
        .snapshots();
  }

  Stream<QuerySnapshot> getTimelineStream() {
    CollectionReference collection = FirebaseFirestore.instance.collection(
        "users/" + (FirebaseAuth.instance.currentUser!.uid) + "/todos");

    final currentDate = DateTime.now().getDateOnly();
    return collection
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
        .orderBy('date')
        .orderBy('isDone')
        .orderBy('order')
        .snapshots();
  }
}
