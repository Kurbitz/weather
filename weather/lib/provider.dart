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
  WeatherLocation _currentWeatherLocation = WeatherLocation(
      latitude: 59.324,
      longitude: 18.071,
      shortName: "Stockholm",
      longName: "Kvarteret Atlas, 111 29 Stockholm");

  WeatherLocation get location => _currentWeatherLocation;

  static const _favoritesKey = "favorites";
  DateTime _lastUpdated;
  final _formatter = DateFormat("d MMMM HH:mm");
  WeatherData? currentWeather;
  List<List<WeatherData>>? weatherForecast;

  late OpenWeatherMap _openWeatherMap;
  List<WeatherLocation> favorites = [];

  String get lastUpdatedString => _formatter.format(_lastUpdated);
  bool get isDaytime => currentWeather?.weather.icon.endsWith("d") ?? true;
  bool get locationIsFavorite => favorites.contains(_currentWeatherLocation);

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

  List<List<WeatherData>> groupForecastByDay(List<WeatherData> forecast) {
    final groupedForecast = <List<WeatherData>>[];
    var currentDay = forecast[0].date.day;
    var currentDayForecast = <WeatherData>[];

    for (var i = 0; i < forecast.length; i++) {
      if (forecast[i].date.day != currentDay) {
        groupedForecast.add(currentDayForecast);
        currentDayForecast = [];
        currentDay = forecast[i].date.day;
      }
      currentDayForecast.add(forecast[i]);
    }
    groupedForecast.add(currentDayForecast);
    return groupedForecast;
  }

  void update() async {
    _lastUpdated = DateTime.now();
    currentWeather = await _openWeatherMap.getCurrentWeather(_currentWeatherLocation);
    final forecast = await _openWeatherMap.getWeatherForecast(_currentWeatherLocation, 40);
    if (forecast != null) {
      weatherForecast = groupForecastByDay(forecast);
    }
    notifyListeners();
  }

  void setLocation(Position position, Placemark? placemark) async {
    String? placeName;
    try {
      placeName = await _openWeatherMap.getReverseGeocoding(position.latitude, position.longitude);
    } catch (e) {
      print(e);
      placeName = coordinatesToDegree(position.latitude, position.longitude);
    }

    _currentWeatherLocation = WeatherLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      shortName: getShortName(placemark, position) ??
          placeName ??
          coordinatesToDegree(position.latitude, position.longitude),
      longName: getLongName(placemark, position),
    );

    update();
  }

  Future<bool> updateLocation() async {
    Position position;
    Placemark? placemark;
    try {
      position = await determinePosition();
    } catch (e) {
      print(e);
      return false;
    }
    try {
      placemark = await determinePlace(position);
    } catch (e) {
      print(e);
    }

    setLocation(position, placemark);
    return true;
  }

  void toggleFavorite() {
    if (locationIsFavorite) {
      removeFavorite(_currentWeatherLocation);
    } else {
      addFavorite(_currentWeatherLocation);
    }
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

    favorites = [...favorites, location];

    saveFavorites();
    notifyListeners();
  }

  void removeFavorite(WeatherLocation location) async {
    if (!await favoritesAreSynced()) {
      favorites = await getSavedFavorites();
    }
    favorites = favorites.where((element) => element != location).toList();
    saveFavorites();
    notifyListeners();
  }

  void clearFavorites() async {
    favorites = [];
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_favoritesKey);
    notifyListeners();
  }

  void setWeatherLocation(WeatherLocation location) {
    _currentWeatherLocation = location;
    update();
  }
}
