import "dart:io";
import "package:flutter/material.dart";
import "package:weather/env/env.dart";
import "package:weather/provider.dart";
import "package:intl/intl.dart";
import "weather.dart";
import "openweathermap.dart";

class WeatherProvider extends ChangeNotifier {
  Location _location = Location(
    latitude: 59.32,
    longitude: 18.07,
    name: "Stockholm",
  );

  DateTime _lastUpdated;
  final _formatter = DateFormat("d MMMM HH:mm");
  WeatherData? weatherData;
  late OpenWeatherMap openWeatherMap;

  String get lastUpdatedString => _formatter.format(_lastUpdated);
  String get location => _location.name ?? "${_location.latitude}, ${_location.longitude}";
  bool get isDaytime => weatherData?.weather.icon.endsWith("d") ?? true;

  // constructor
  WeatherProvider() : _lastUpdated = DateTime.now() {
    openWeatherMap = OpenWeatherMap(Env.OPENWEATHERMAP_API_KEY);
    update();
  }

  void update() async {
    _lastUpdated = DateTime.now();
    weatherData = await openWeatherMap.getWeather(_location);
    print(weatherData!.weather.id);
    notifyListeners();
  }
}
