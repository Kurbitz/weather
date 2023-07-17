class WeatherData {
  final DateTime lastUpdated;
  final Wind wind;

  final double temperature;
  final double feelsLike;
  final int pressure;
  final int humidity;
  final Weather weather;

  WeatherData({
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
      weather: Weather.fromJson(json["weather"][0]),
      wind: Wind.fromJson(json["wind"]),
      temperature: json["main"]["temp"] + .0,
      feelsLike: json["main"]["feels_like"] + .0,
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
  final String latitude;
  final String longitude;
  final String shortName;
  final String longName;

  WeatherLocation({
    required double latitude,
    required double longitude,
    required this.shortName,
    required this.longName,
  })  : latitude = latitude.toStringAsFixed(3),
        longitude = longitude.toStringAsFixed(3);

  factory WeatherLocation.fromJson(Map<String, dynamic> json) {
    return WeatherLocation(
      latitude: json["lat"],
      longitude: json["lon"],
      shortName: json["shortName"] ?? "",
      longName: json["longName"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "lat": num.parse(latitude),
      "lon": num.parse(longitude),
      "shortName": shortName,
      "longName": longName,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherLocation &&
          runtimeType == other.runtimeType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          shortName == other.shortName;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ shortName.hashCode;
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
      speed: json["speed"] + .0,
      direction: json["deg"],
    );
  }
}
