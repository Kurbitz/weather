import "dart:async";
import "package:flutter/material.dart";
import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";
import "package:weather/env/env.dart";
import "package:weather/location.dart";
import "package:intl/intl.dart";
import "weather.dart";
import "openweathermap.dart";

class WeatherProvider extends ChangeNotifier {
  WeatherLocation _currentLocation = WeatherLocation(
    latitude: 59.32,
    longitude: 18.07,
    name: "Stockholm",
  );

  DateTime _lastUpdated;
  final _formatter = DateFormat("d MMMM HH:mm");
  WeatherData? weatherData;
  late OpenWeatherMap _openWeatherMap;

  String get lastUpdatedString => _formatter.format(_lastUpdated);
  String get location =>
      _currentLocation.name ?? "${_currentLocation.latitude}, ${_currentLocation.longitude}";
  bool get isDaytime => weatherData?.weather.icon.endsWith("d") ?? true;

  WeatherProvider() : _lastUpdated = DateTime.now() {
    _openWeatherMap = OpenWeatherMap(Env.OPENWEATHERMAP_API_KEY);
    update();
    // Update every 10 minutes
    Timer.periodic(const Duration(minutes: 10), (timer) {
      update();
    });
  }

  void update() async {
    _lastUpdated = DateTime.now();
    weatherData = await _openWeatherMap.getWeather(_currentLocation);
    print(weatherData!.weather.id);
    notifyListeners();
  }

  void setLocation(Position position, Placemark? placemark) {
    String name;
    if (placemark != null) {
      print(placemark.toJson());
      if (placemark.subLocality != null && placemark.subLocality!.isNotEmpty) {
        name = placemark.subLocality!;
      } else if (placemark.locality != null && placemark.locality!.isNotEmpty) {
        name = placemark.locality!;
      } else if (placemark.street != null && placemark.street!.isNotEmpty) {
        name = placemark.street!;
      } else if (placemark.administrativeArea != null && placemark.administrativeArea!.isNotEmpty) {
        name = placemark.administrativeArea!;
      } else {
        name = "${position.latitude}, ${position.longitude}";
      }
    } else {
      name =
          "${position.latitude.toStringAsPrecision(3)}, ${position.longitude.toStringAsPrecision(3)}";
    }

    print(name);
    _currentLocation = WeatherLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      name: name,
    );
    update();
  }

  void updateLocation() async {
    Position position;
    Placemark? placemark;
    try {
      position = await determinePosition();
    } catch (e) {
      print(e);
      return;
    }
    try {
      placemark = await determinePlace(position);
    } catch (e) {
      print(e);
    }

    setLocation(position, placemark);
  }
}
