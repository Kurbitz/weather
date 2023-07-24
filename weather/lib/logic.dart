// Converts meters per second to Beaufort scale (0-12) which is used to describe wind speed
int metersPerSecondToBeaufort(double speed) {
  if (speed < 0.5 && speed >= 0) {
    return 0;
  } else if (speed < 1.5) {
    return 1;
  } else if (speed < 3.3) {
    return 2;
  } else if (speed < 5.5) {
    return 3;
  } else if (speed < 8) {
    return 4;
  } else if (speed < 10.8) {
    return 5;
  } else if (speed < 13.9) {
    return 6;
  } else if (speed < 17.2) {
    return 7;
  } else if (speed < 20.8) {
    return 8;
  } else if (speed < 24.5) {
    return 9;
  } else if (speed < 28.5) {
    return 10;
  } else if (speed < 32.7) {
    return 11;
  } else if (speed >= 32.7) {
    return 12;
  } else {
    throw Exception("Invalid wind speed");
  }
}

// Converts a timestamp to a string of the form "HH-hh"  where HH is the start hour and hh is the end hour which is HH + span
String timestampToHourSpan(int timestamp, int span) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var hour = date.hour;
  var start = hour.toString().padLeft(2, '0');
  var end = ((hour + span) % 24).toString().padLeft(2, '0');
  return "$start-$end";
}
