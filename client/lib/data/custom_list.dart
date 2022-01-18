import 'package:cloud_firestore/cloud_firestore.dart';

class CustomList {
  final String name;
  int? order;
  DocumentReference? reference;

  CustomList({
    required this.name,
    required this.order,
    this.reference,
  });

  factory CustomList.fromJson(Map<dynamic, dynamic> json) => CustomList(
        name: json['name'] as String,
        order: (json['order'] as int?),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'order': order,
      };

  factory CustomList.fromSnapshot(DocumentSnapshot snapshot) {
    final todo = CustomList.fromJson(snapshot.data() as Map<String, dynamic>);
    todo.reference = snapshot.reference;
    return todo;
  }
}
