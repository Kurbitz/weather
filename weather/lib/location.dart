import 'package:geolocator/geolocator.dart';
import "package:geocoding/geocoding.dart";
import 'package:weather/weather.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future<Placemark> _determinePlace(Position position) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  return placemarks[0];
}

String _getLongName(Placemark? placemarkLocation, Position position) {
  if (placemarkLocation != null) {
    if (placemarkLocation.street != null &&
        placemarkLocation.street!.isNotEmpty &&
        placemarkLocation.postalCode != null &&
        placemarkLocation.postalCode!.isNotEmpty &&
        placemarkLocation.administrativeArea != null &&
        placemarkLocation.administrativeArea!.isNotEmpty) {
      return "${placemarkLocation.street}, ${placemarkLocation.postalCode}, ${placemarkLocation.administrativeArea}";
    }
  }

  return coordinatesToDegree(position.latitude, position.longitude);
}

String? _getShortName(Placemark? placemarkLocation, Position position) {
  if (placemarkLocation != null) {
    if (placemarkLocation.subLocality != null && placemarkLocation.subLocality!.isNotEmpty) {
      return placemarkLocation.subLocality!;
    } else if (placemarkLocation.locality != null && placemarkLocation.locality!.isNotEmpty) {
      return placemarkLocation.locality!;
    } else if (placemarkLocation.street != null && placemarkLocation.street!.isNotEmpty) {
      return placemarkLocation.street!;
    }
  }

  return null;
}

String coordinatesToDegree(double latitude, double longitude) {
  final latDirection = latitude.isNegative ? "S" : "N";
  final lonDirection = longitude.isNegative ? "W" : "E";

  final latDegree = latitude.truncate().abs();
  final latMinute = ((latitude.abs() - latDegree) * 60).truncate();
  final latSecond = ((((latitude.abs() - latDegree) * 60) - latMinute) * 60).truncate();

  final lonDegree = longitude.truncate().abs();
  final lonMinute = ((longitude.abs() - lonDegree) * 60).truncate();
  final lonSecond = ((((longitude.abs() - lonDegree) * 60) - lonMinute) * 60).truncate();

  return "$latDegree°$latMinute'$latSecond\"$latDirection $lonDegree°$lonMinute'$lonSecond\"$lonDirection";
}

Future<WeatherLocation> getLocation() async {
  Position position;
  Placemark? placemark;
  try {
    position = await _determinePosition();
  } catch (e) {
    print(e);
    return Future.error(e);
  }
  try {
    placemark = await _determinePlace(position);
  } catch (e) {
    print(e);
  }

  return WeatherLocation(
    latitude: position.latitude,
    longitude: position.longitude,
    shortName: _getShortName(placemark, position) ??
        coordinatesToDegree(position.latitude, position.longitude),
    longName: _getLongName(placemark, position),
  );
}
