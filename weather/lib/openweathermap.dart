import "dart:io";
import "package:weather/weather.dart";
import "dart:convert";

class OpenWeatherMap {
  final String _apiKey;
  final String _apiUrlBase = "https://api.openweathermap.org/data/2.5/weather";

  OpenWeatherMap(this._apiKey);

  Future<WeatherData> getWeather(WeatherLocation location) async {
    final uri = Uri.parse(
        "$_apiUrlBase?lat=${location.latitude}&lon=${location.longitude}&appid=$_apiKey&units=metric");
    final response = await HttpClient().getUrl(uri).then((request) => request.close());
    final responseBody = await response.transform(const Utf8Decoder()).join();
    final json = jsonDecode(responseBody);
    return WeatherData.fromJson(json);
  }
}
