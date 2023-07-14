class WeatherData {
  final DateTime lastUpdated;
  final WeatherLocation location;
  final Wind wind;

  final double temperature;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final Weather weather;

  WeatherData({
    required this.location,
    required this.weather,
    required this.temperature,
    required this.feelsLike,
    required this.wind,
    required this.pressure,
    required this.humidity,
    required this.lastUpdated,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      location: WeatherLocation.fromJson(json["coord"]),
      weather: Weather.fromJson(json["weather"][0]),
      wind: Wind.fromJson(json["wind"]),
      temperature: json["main"]["temp"],
      feelsLike: json["main"]["feels_like"],
      pressure: json["main"]["pressure"],
      humidity: json["main"]["humidity"],
      lastUpdated: DateTime.now(),
    );
  }
}

class Weather {
  final int id;
  final String main;
  final String description;
  final String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      id: json["id"],
      main: json["main"],
      description: json["description"],
      icon: json["icon"],
    );
  }
}

class WeatherLocation {
  final double latitude;
  final double longitude;
  final String? name;

  WeatherLocation({
    required this.latitude,
    required this.longitude,
    this.name,
  });

  factory WeatherLocation.fromJson(Map<String, dynamic> json) {
    return WeatherLocation(
      latitude: json["lat"],
      longitude: json["lon"],
    );
  }
}

class Wind {
  final double speed;
  final int direction;

  Wind({
    required this.speed,
    required this.direction,
  });

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: json["speed"],
      direction: json["deg"],
    );
  }
}
