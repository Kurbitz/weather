extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isAfterTimeOnly(DateTime other) {
    return hour > other.hour ||
        (hour == other.hour && minute > other.minute) ||
        (hour == other.hour && minute == other.minute && second > other.second);
  }

  bool isBeforeTimeOnly(DateTime other) {
    return hour < other.hour ||
        (hour == other.hour && minute < other.minute) ||
        (hour == other.hour && minute == other.minute && second < other.second);
  }
}

extension StringExtention on String {
  String capitalize() {
    return isNotEmpty ? "${this[0].toUpperCase()}${substring(1)}" : this;
  }
}
