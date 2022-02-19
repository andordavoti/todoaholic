extension MyDateExtension on DateTime {
  DateTime getDateOnly() {
    return DateTime(year, month, day);
  }

  DateTime toDayStart() {
    return DateTime(year, month, day, 0, 0, 0);
  }

  DateTime toDayEnd() {
    return DateTime(year, month, day, 23, 59, 59);
  }
}
