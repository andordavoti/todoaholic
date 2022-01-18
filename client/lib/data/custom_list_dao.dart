import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoaholic/data/custom_list.dart';
import 'package:todoaholic/data/todo.dart';

class CustomListDao {
  final firestore = FirebaseFirestore.instance;

  Future<void> save(CustomList list, Todo todo) async {
    await list.reference!.collection('todos').add(todo.toJson());
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

  Future<void> remove(Todo todo) async {
    await todo.reference?.delete();
  }

  Stream<QuerySnapshot> getStream(CustomList list) {
    return list.reference!
        .collection('todos')
        .orderBy('isDone')
        .orderBy('order')
        .snapshots();
  }
}
