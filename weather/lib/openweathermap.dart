import "dart:io";
import "package:weather/weather.dart";
import "dart:convert";

class OpenWeatherMap {
  final String _apiKey;
  final String _apiUrlBase = "https://api.openweathermap.org/data/2.5/weather";
  final String _host = "api.openweathermap.org";
  final String _basePath = "data/2.5";

  OpenWeatherMap(this._apiKey);

  Future<WeatherData> getWeather(WeatherLocation location) async {
    final uri = Uri.parse(
        "$_apiUrlBase?lat=${location.latitude}&lon=${location.longitude}&appid=$_apiKey&units=metric");
    final response = await HttpClient().getUrl(uri).then((request) => request.close());
    final responseBody = await response.transform(const Utf8Decoder()).join();
    final json = jsonDecode(responseBody);
    return WeatherData.fromJson(json);
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
}
