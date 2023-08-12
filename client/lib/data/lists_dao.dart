import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoaholic/data/custom_list.dart';

class ListsDao {
  final firestore = FirebaseFirestore.instance;

  Future<void> save(CustomList list) async {
    CollectionReference collection = firestore
        .collection('users/${FirebaseAuth.instance.currentUser!.uid}/lists');

    await collection.add(list.toJson());
  }

  Future<void> update(CustomList list, String newName) async {
    await list.reference?.update({
      'name': newName,
    });
  }

  Future<void> setOrder(CustomList list, int order) async {
    await list.reference?.update({'order': order});
  }

  Future<void> remove(CustomList list) async {
    await list.reference?.delete();
  }

  Stream<QuerySnapshot> getStream() {
    CollectionReference collection = firestore
        .collection('users/${FirebaseAuth.instance.currentUser!.uid}/lists');

    return collection.orderBy('order').snapshots();
  }
}
