// This file contains various extentions, which are used to extend the functionality of existing classes.

extension DateOnlyCompare on DateTime {
  /// Returns true if the date part of this DateTime is the same as the date part of [other].
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isAfterTimeOnly(DateTime other) {
    /// Returns true if the time part of this DateTime is after the time part of [other].
    /// The date parts of the objects are ignored.
    return hour > other.hour ||
        (hour == other.hour && minute > other.minute) ||
        (hour == other.hour && minute == other.minute && second > other.second);
  }

  bool isBeforeTimeOnly(DateTime other) {
    /// Returns true if the time part of this DateTime is before the time part of [other].
    /// The date parts of the objects are ignored.
    return hour < other.hour ||
        (hour == other.hour && minute < other.minute) ||
        (hour == other.hour && minute == other.minute && second < other.second);
  }
}

extension StringExtention on String {
  /// Capitalizes the first letter of this string.
  String capitalize() {
    return isNotEmpty ? "${this[0].toUpperCase()}${substring(1)}" : this;
  }
}
