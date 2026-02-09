extension DateExt on DateTime {
  bool isSameDate(DateTime value) {
    return day == value.day && month == value.month && year == value.year;
  }
}
