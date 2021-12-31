import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/datetime_extension.dart';
import 'todo.dart';

class TodoDao {
  CollectionReference? collection = FirebaseFirestore.instance.collection(
      "users/" + (FirebaseAuth.instance.currentUser!.uid) + "/todos");

  Future<void> save(Todo todo) async {
    await collection?.add(todo.toJson());
  }

  Future<void> update(Todo todo, String newText, DateTime newDate) async {
    await todo.reference
        ?.update({'text': newText, 'date': Timestamp.fromDate(newDate)});
  }

  Future<void> setDone(Todo todo) async {
    await todo.reference?.update({'isDone': true});
  }

  Future<void> setNotDone(Todo todo) async {
    await todo.reference?.update({'isDone': false});
  }

  Future<void> swipeTomorrow(Todo todo) async {
    DateTime nextDay = todo.date.toDate().add(const Duration(days: 1));
    await todo.reference?.update({'date': Timestamp.fromDate(nextDay)});
  }

  Future<void> moveToToday(Todo todo) async {
    final currentDate = DateTime.now().getDateOnly();
    await todo.reference?.update({'date': Timestamp.fromDate(currentDate)});
  }

  Future<void> remove(Todo todo) async {
    await todo.reference?.delete();
  }

  Stream<QuerySnapshot> getPresentStream(DateTime selectedDate) {
    final currentDate = DateTime.now().getDateOnly();

    if (selectedDate.isBefore(currentDate)) {
      return collection!
          .where('date', isEqualTo: Timestamp.fromDate(selectedDate))
          .where('isDone', isEqualTo: true)
          .snapshots();
    } else {
      return collection!
          .where('date', isEqualTo: Timestamp.fromDate(selectedDate))
          .orderBy('isDone')
          .snapshots();
    }
  }

  Stream<QuerySnapshot> getUndonePastStream(DateTime selectedDate) {
    return collection!
        .where('isDone', isEqualTo: false)
        .where('date', isLessThan: Timestamp.fromDate(selectedDate))
        .snapshots();
  }

  Stream<QuerySnapshot> getTimelineStream() {
    final currentDate = DateTime.now().getDateOnly();

    return collection!
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(currentDate))
        .orderBy('date')
        .orderBy('isDone')
        .snapshots();
  }
}
