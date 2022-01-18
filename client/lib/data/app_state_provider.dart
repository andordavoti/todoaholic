import 'package:flutter/material.dart';
import 'package:todoaholic/data/custom_list.dart';
import '../utils/datetime_extension.dart';

class AppState extends ChangeNotifier {
  DateTime selectedDate = DateTime.now().getDateOnly();
  CustomList? selectedList;

  void decrementSelectedDate() {
    selectedDate = selectedDate.add(const Duration(days: -1));
    notifyListeners();
  }

  void incrementSelectedDate() {
    selectedDate = selectedDate.add(const Duration(days: 1));
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date.getDateOnly();
    notifyListeners();
  }

  void setSelectedList(CustomList list) {
    selectedList = list;
    notifyListeners();
  }
}
