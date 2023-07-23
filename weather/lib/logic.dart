int metersPerSecondToBeufort(double speed) {
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
