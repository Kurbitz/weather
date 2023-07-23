import "dart:io";
import "dart:convert";
import "package:weather/weather.dart";

class OpenWeatherMap {
  final String _apiKey;
  final String _host = "api.openweathermap.org";

  OpenWeatherMap(this._apiKey);

  // TODO: Add error handling
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
      print(json);
      return WeatherData.fromJson(json);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<String?> getReverseGeocoding(double latitude, double longitude) async {
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
        return null;
      }
      return json[0]["name"];
    } catch (e) {
      return null;
    }
  }

  Future<List<WeatherData>?> getWeatherForecast(WeatherLocation location, int count) async {
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
        return null;
      }

      final list = json["list"] as List<dynamic>;
      return list.map((e) => WeatherData.fromJson(e)).toList();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
