extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

extension StringExtention on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
