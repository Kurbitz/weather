import "dart:async";
import "dart:convert";
import "package:flutter/material.dart";
import "package:weather/env/env.dart";
import "package:weather/location.dart";
import "package:intl/intl.dart";
import "package:weather/weather.dart";
import "package:weather/openweathermap.dart";
import "package:shared_preferences/shared_preferences.dart";

class WeatherProvider extends ChangeNotifier {
  Completer _completer = Completer();

  Future<dynamic> get isReady => _completer.future;

  WeatherLocation? _currentWeatherLocation;

  WeatherLocation? get location => _currentWeatherLocation;

  static const _favoritesKey = "favorites";
  DateTime _lastUpdated;
  final _formatter = DateFormat("d MMMM HH:mm");
  WeatherData? currentWeather;
  List<List<WeatherData>>? weatherForecast;

  late OpenWeatherMap _openWeatherMap;
  List<WeatherLocation> favorites = [];

  String get lastUpdatedString => _formatter.format(_lastUpdated);

  bool get locationIsFavorite => favorites.contains(_currentWeatherLocation);

  WeatherProvider() : _lastUpdated = DateTime.now() {
    _openWeatherMap = OpenWeatherMap(Env.OPENWEATHERMAP_API_KEY);
    getLocation().then((value) {
      _currentWeatherLocation = value;
      _updateWeather().then((value) {
        _completer.complete();
      }).onError((error, stackTrace) {
        _completer.completeError(error!, stackTrace);
      });
      return;
    }).onError(
      (error, stackTrace) {
        if (favorites.isNotEmpty) {
          _currentWeatherLocation = favorites[0];
          _updateWeather().then((value) {
            _completer.complete();
          }).onError((error, stackTrace) {
            _completer.completeError(error!, stackTrace);
          });
          return;
        } else {
          _completer.completeError(error!, stackTrace);
        }
      },
    );
    getSavedFavorites().then((value) {
      favorites = value;
    });
    // Update every 10 minutes
    Timer.periodic(const Duration(minutes: 10), (timer) {
      _updateWeather();
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

  void reload() async {
    _completer = Completer();
    notifyListeners();
    try {
      await _updateLocation();
      await _updateWeather();
      _completer.complete();
    } catch (e) {
      _completer.completeError(e);
    }
    notifyListeners();
  }

  Future<void> updateWeather() async {
    try {
      await _updateWeather();
    } catch (e) {
      return Future.error(e);
    }
    notifyListeners();
  }

  Future<void> updateLocation() async {
    try {
      await _updateLocation();
    } catch (e) {
      return Future.error(e);
    }
    notifyListeners();
  }

  Future<void> _updateWeather() async {
    if (_currentWeatherLocation == null) {
      return Future.error("No location");
    }
    _lastUpdated = DateTime.now();
    List<WeatherData> forecast;
    try {
      currentWeather = await _openWeatherMap.getCurrentWeather(_currentWeatherLocation!);
      forecast = await _openWeatherMap.getWeatherForecast(_currentWeatherLocation!, 40);
    } catch (e) {
      print(e);

      return Future.error(e);
    }
    weatherForecast = groupForecastByDay(forecast);
  }

  Future<void> _updateLocation() async {
    try {
      final location = await getLocation();
      _currentWeatherLocation = location;
      return;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  void toggleFavorite() {
    if (_currentWeatherLocation == null) {
      return;
    }

    if (locationIsFavorite) {
      removeFavorite(_currentWeatherLocation!);
    } else {
      addFavorite(_currentWeatherLocation!);
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
    _updateWeather();
  }
}
