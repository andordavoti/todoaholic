import 'package:flutter/material.dart';
import '../utils/datetime_extension.dart';

class AppState extends ChangeNotifier {
  DateTime selectedDate = DateTime.now().getDateOnly();

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
}
