import "dart:io";
import "dart:convert";
import "package:flutter/foundation.dart";
import "package:weather/weather.dart";

/// OpenWeatherMap API wrapper.
/// Provides an interface for getting weather data from the OpenWeatherMap API.
class OpenWeatherMap {
  final String _apiKey;
  final String _host = "api.openweathermap.org";

  /// Creates a new OpenWeatherMap instance with the given [apiKey].
  OpenWeatherMap(this._apiKey);

  /// Used to get the current weather for the given [location].
  /// Returns a [WeatherData] object if the request was successful.
  /// Throws a Future.error if the request was unsuccessful.
  Future<WeatherData> getCurrentWeather(WeatherLocation location) async {
    final uri = Uri(
      scheme: "https",
      host: _host,
      path: "data/2.5/weather",
      queryParameters: {
        "lat": location.latitude,
        "lon": location.longitude,
        "appid": _apiKey,
        "units": "metric",
      },
    );

    try {
      final response = await HttpClient().getUrl(uri).then((request) => request.close());
      final responseBody = await response.transform(const Utf8Decoder()).join();
      final json = jsonDecode(responseBody);
      if (kDebugMode) {
        print(json);
      }
      return WeatherData.fromJson(json);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  /// Used to get location information for the given [latitude] and [longitude].
  /// Returns a string with the name of the location if the request was successful.
  /// Throws a Future.error if the request was unsuccessful.
  // This is not used in the app right now, but it might be useful in the future instead of
  // using the Geocoding package.
  Future<String> getReverseGeocoding(double latitude, double longitude) async {
    final uri = Uri(
      scheme: "https",
      host: _host,
      path: "geo/1.0/reverse",
      queryParameters: {
        "lat": latitude,
        "lon": longitude,
        "appid": _apiKey,
        "limit": "1",
      },
    );

    try {
      final response = await HttpClient().getUrl(uri).then((request) => request.close());
      final responseBody = await response.transform(const Utf8Decoder()).join();
      final json = jsonDecode(responseBody);

      if (response.statusCode != 200) {
        return Future.error(json["message"]);
      }
      return json[0]["name"];
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  /// Used to get the 5 day weather forecast for the given [location].
  /// Returns a list of [WeatherData] objects if the request was successful.
  /// Throws a Future.error if the request was unsuccessful.
  /// The [count] parameter is used to specify how many data points should be returned.
  Future<List<WeatherData>> getWeatherForecast(WeatherLocation location, int count) async {
    final uri = Uri(
      scheme: "https",
      host: _host,
      path: "data/2.5/forecast",
      queryParameters: {
        "lat": location.latitude,
        "lon": location.longitude,
        "appid": _apiKey,
        "units": "metric",
        "cnt": count.toString(),
      },
    );

    try {
      final response = await HttpClient().getUrl(uri).then((request) => request.close());
      final responseBody = await response.transform(const Utf8Decoder()).join();
      final json = jsonDecode(responseBody);

      if (response.statusCode != 200) {
        return Future.error(json["message"]);
      }

      return WeatherData.fromForecastJson(json);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }
}
