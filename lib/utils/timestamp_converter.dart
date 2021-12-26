import 'package:cloud_firestore/cloud_firestore.dart';

class TimestampConverter {
  static Timestamp parseString(String dateString) {
    int equalsIndex = 0;
    int commaIndex = 0;

    for (int i = 0; i < dateString.length; i++) {
      if (dateString[i] == '=') {
        equalsIndex = i;
      }
      if (dateString[i] == ',') {
        commaIndex = i;
        break;
      }
    }

    String secondsString = dateString.substring(equalsIndex + 1, commaIndex);
    int seconds = int.parse(secondsString);
    return Timestamp(seconds, 0);
  }
}
