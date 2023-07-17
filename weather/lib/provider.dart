import "dart:async";
import "dart:convert";
import "package:flutter/material.dart";
import "package:geocoding/geocoding.dart";
import "package:geolocator/geolocator.dart";
import "package:weather/env/env.dart";
import "package:weather/location.dart";
import "package:intl/intl.dart";
import "package:weather/weather.dart";
import "package:weather/openweathermap.dart";
import "package:shared_preferences/shared_preferences.dart";

class WeatherProvider extends ChangeNotifier {
  WeatherLocation _currentLocation = WeatherLocation(
    latitude: 59.32,
    longitude: 18.07,
    name: "Stockholm",
  );
  static const _favoritesKey = "favorites";
  DateTime _lastUpdated;
  final _formatter = DateFormat("d MMMM HH:mm");
  WeatherData? weatherData;
  late OpenWeatherMap _openWeatherMap;
  List<WeatherLocation> favorites = [];

  String get lastUpdatedString => _formatter.format(_lastUpdated);
  String get location =>
      _currentLocation.name ?? "${_currentLocation.latitude}, ${_currentLocation.longitude}";
  bool get isDaytime => weatherData?.weather.icon.endsWith("d") ?? true;

  WeatherProvider() : _lastUpdated = DateTime.now() {
    _openWeatherMap = OpenWeatherMap(Env.OPENWEATHERMAP_API_KEY);
    updateLocation();
    getSavedFavorites().then((value) {
      favorites = value;
    });
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

  Future<List<WeatherLocation>> getSavedFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedFavorites;
    try {
      savedFavorites = prefs.getStringList(_favoritesKey) ?? [];
    } catch (e) {
      print(e);
      savedFavorites = [];
    }
    return savedFavorites.map((e) => WeatherLocation.fromJson(jsonDecode(e))).toList();
  }

  Future<bool> favoritesAreSynced() async {
    final savedFavorites = await getSavedFavorites();

    if (savedFavorites.length != favorites.length) {
      return false;
    }

    for (var i = 0; i < favorites.length; i++) {
      if (!savedFavorites.contains(favorites[i])) {
        return false;
      }
    }
    return true;
  }

  void saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = favorites.map((e) => jsonEncode(e.toJson())).toList();
    prefs.setStringList(_favoritesKey, favoritesJson);
  }

  void addFavorite(WeatherLocation location) async {
    if (!await favoritesAreSynced()) {
      favorites = await getSavedFavorites();
    }
    favorites.add(location);
    notifyListeners();
    saveFavorites();
  }
}
