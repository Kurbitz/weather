import "dart:async";
import "dart:convert";
import "package:flutter/foundation.dart";
import "package:weather/env/env.dart";
import "package:weather/location.dart";
import "package:intl/intl.dart";
import "package:weather/weather.dart";
import "package:weather/openweathermap.dart";
import "package:shared_preferences/shared_preferences.dart";

/// Contains the state of the app.
// Using a Provider to manage the state of the app makes it easier to share the state between
// different widgets. I could probably make this app work without using a Provider, but I wanted to
// try it out as it seems like a good way to manage the state of the app. It also makes it easier
// to add new features to the app in the future since state is centralized in one place.
class WeatherProvider extends ChangeNotifier {
  // Used to notify the app when the WeatherProvider is ready to be used.
  Completer _completer = Completer();

  /// When this future completes, the WeatherProvider is ready to be used.
  Future<dynamic> get onReady => _completer.future;

  /// The current location
  WeatherLocation? _currentWeatherLocation;
  // Public getter is used to prevent accidental mutation
  WeatherLocation? get location => _currentWeatherLocation;

  /// The key used to store the favorites in the shared preferences.
  static const _favoritesKey = "favorites";

  /// The last time the weather was updated.
  DateTime _lastUpdated;

  /// Used to format the last updated time.
  final _formatter = DateFormat("d MMMM HH:mm");

  /// The current weather.
  // TODO: Add getter and make this private.
  WeatherData? currentWeather;

  /// The weather forecast, grouped by day
  // TODO: Encapsulate this in a class instead of using a list of lists.
  List<List<WeatherData>>? weatherForecast;

  /// The OpenWeatherMap API instance.
  late OpenWeatherMap _openWeatherMap;

  /// The list of favorite locations.
  List<WeatherLocation> favorites = [];

  /// The last time the weather was updated as a string.
  String get lastUpdatedString => _formatter.format(_lastUpdated);

  /// Returns true if the current location is a favorite.
  bool get locationIsFavorite => favorites.contains(_currentWeatherLocation);

  /// Creates a new WeatherProvider instance.
  /// The WeatherProvider is ready to be used when the [onReady] future completes.
  /// The WeatherProvider will update the weather every 10 minutes.
  /// If the location can't be determined, the first favorite location will be used instead.
  /// If the location can't be determined and there are no favorite locations, the completer will
  /// complete with an error.
  /// If the weather can't be updated, the completer will complete with an error.
  WeatherProvider() : _lastUpdated = DateTime.now() {
    // Initialize the OpenWeatherMap API instance.
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
    // Load favorites
    getSavedFavorites().then((value) {
      favorites = value;
    });
    // Update every 10 minutes
    Timer.periodic(const Duration(minutes: 10), (timer) {
      _updateWeather();
    });
  }

  /// Groups the given [forecast] by day.
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

  /// Reloads the location and weather.
  void reload() async {
    // Reset completer as the entire state of the app is being reloaded.
    _completer = Completer();
    notifyListeners();
    try {
      await _updateLocation();
      await _updateWeather();
      // If location and weather was updated successfully, complete the completer, signaling that
      // the WeatherProvider is ready to be used.
      _completer.complete();
    } catch (e) {
      _completer.completeError(e);
    }
    notifyListeners();
  }

  // The following methods are split into public and private methods.
  // This is because the public methods are used by widgets to update the state of the app and
  // need to call notifyListeners() to notify the app that the state has changed.
  // The private methods are used by the WeatherProvider itself and should not call notifyListeners()
  // as this would cause the app to rebuild unnecessarily.

  /// Public method used to update the weather.
  Future<void> updateWeather() async {
    try {
      await _updateWeather();
    } catch (e) {
      return Future.error(e);
    }
    notifyListeners();
  }

  /// Public method used to update the location.
  Future<void> updateLocation() async {
    try {
      await _updateLocation();
      await _updateWeather();
    } catch (e) {
      return Future.error(e);
    }
    notifyListeners();
  }

  /// Updates the weather.
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
      if (kDebugMode) {
        print(e);
      }

      return Future.error(e);
    }
    weatherForecast = groupForecastByDay(forecast);
  }

  /// Updates the location.
  Future<void> _updateLocation() async {
    try {
      final location = await getLocation();
      _currentWeatherLocation = location;
      return;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return Future.error(e);
    }
  }

  /// Toggles the favorite status of the current location.
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

  /// Returns a list of saved favorites from the shared preferences.
  Future<List<WeatherLocation>> getSavedFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedFavorites;
    // If the favorites key doesn't exist, set savedFavorites to an empty list.
    try {
      savedFavorites = prefs.getStringList(_favoritesKey) ?? [];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      savedFavorites = [];
    }
    // Convert the json strings to WeatherLocation objects.
    return savedFavorites.map((e) => WeatherLocation.fromJson(jsonDecode(e))).toList();
  }

  /// Returns true if the favorites in the shared preferences are the same as the favorites in memory.
  /// Returns false if the favorites are not the same.
  Future<bool> _favoritesAreSynced() async {
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

  /// Saves the favorites to the shared preferences.
  void _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // Convert the WeatherLocation objects to json strings.
    final favoritesJson = favorites.map((e) => jsonEncode(e.toJson())).toList();
    prefs.setStringList(_favoritesKey, favoritesJson);
  }

  /// Adds the given [location] to the favorites.
  void addFavorite(WeatherLocation location) async {
    if (!await _favoritesAreSynced()) {
      favorites = await getSavedFavorites();
    }

    favorites = [...favorites, location];

    _saveFavorites();
    notifyListeners();
  }

  /// Removes the given [location] from the favorites.
  void removeFavorite(WeatherLocation location) async {
    if (!await _favoritesAreSynced()) {
      favorites = await getSavedFavorites();
    }
    favorites = favorites.where((element) => element != location).toList();
    _saveFavorites();
    notifyListeners();
  }

  /// Clears all favorites from the shared preferences.
  void clearFavorites() async {
    favorites = [];
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_favoritesKey);
    notifyListeners();
  }

  /// Sets the current location to the given [location].
  /// This will also update the weather.
  Future<void> setWeatherLocation(WeatherLocation location) async {
    _currentWeatherLocation = location;
    await _updateWeather();
    notifyListeners();
  }
}
