import 'package:weather/extentions.dart';
import 'package:weather/logic.dart';

class WeatherData {
  final Weather weather;
  final Wind wind;
  final Rain rain;

  final double temperature;
  final double feelsLike;
  final double? probabilityOfPrecipitation;
  final int pressure;
  final int humidity;

  final int timeStamp;
  final int sunrise;
  final int sunset;

  WeatherData({
    required this.weather,
    required this.wind,
    required this.rain,
    required this.temperature,
    required this.feelsLike,
    required this.probabilityOfPrecipitation,
    required this.pressure,
    required this.humidity,
    required this.timeStamp,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      weather: Weather.fromJson(json["weather"][0]),
      wind: Wind.fromJson(json["wind"]),
      rain: Rain.fromJson(json["rain"]),
      temperature: json["main"]["temp"] + .0,
      feelsLike: json["main"]["feels_like"] + .0,
      probabilityOfPrecipitation: json["pop"]?.toDouble(),
      pressure: json["main"]["pressure"],
      humidity: json["main"]["humidity"],
      timeStamp: json["dt"],
      sunrise: json["sys"]["sunrise"],
      sunset: json["sys"]["sunset"],
    );
  }

  DateTime get date => DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  DateTime get sunriseTime => DateTime.fromMillisecondsSinceEpoch(sunrise * 1000);
  DateTime get sunsetTime => DateTime.fromMillisecondsSinceEpoch(sunset * 1000);
  bool get isDaytime => date.isAfterTimeOnly(sunriseTime) && date.isBeforeTimeOnly(sunsetTime);

  static List<WeatherData> fromForecastJson(Map<String, dynamic> json) {
    return List<WeatherData>.from(
      json["list"].map(
        (x) {
          return WeatherData(
            weather: Weather.fromJson(x["weather"][0]),
            wind: Wind.fromJson(x["wind"]),
            rain: Rain.fromJson(x["rain"]),
            temperature: x["main"]["temp"] + .0,
            feelsLike: x["main"]["feels_like"] + .0,
            probabilityOfPrecipitation: x["pop"]?.toDouble(),
            pressure: x["main"]["pressure"],
            humidity: x["main"]["humidity"],
            timeStamp: x["dt"],
            sunrise: json["city"]["sunrise"],
            sunset: json["city"]["sunset"],
          );
        },
      ),
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
          longitude == other.longitude;

  @override
  int get hashCode => latitude.hashCode ^ longitude.hashCode ^ shortName.hashCode;
}

class Wind {
  final double speed;
  final int direction;

  // Converts degrees to cardinal direction
  // http://snowfence.umn.edu/Components/winddirectionanddegrees.htm
  String get cardinalDirection {
    if (direction >= 348.75 || direction < 11.25) {
      return "north";
    } else if (direction < 33.75) {
      return "north-northeast";
    } else if (direction < 56.25) {
      return "northeast";
    } else if (direction < 78.75) {
      return "east-northeast";
    } else if (direction < 101.25) {
      return "east";
    } else if (direction < 123.75) {
      return "east-southeast";
    } else if (direction < 146.25) {
      return "southeast";
    } else if (direction < 168.75) {
      return "south-southeast";
    } else if (direction < 191.25) {
      return "south";
    } else if (direction < 213.75) {
      return "south-southwest";
    } else if (direction < 236.25) {
      return "southwest";
    } else if (direction < 258.75) {
      return "west-southwest";
    } else if (direction < 281.25) {
      return "west";
    } else if (direction < 303.75) {
      return "west-northwest";
    } else if (direction < 326.25) {
      return "northwest";
    } else if (direction < 348.75) {
      return "north-northwest";
    } else {
      throw Exception("Invalid wind direction");
    }
  }

  int get beaufort => metersPerSecondToBeaufort(speed);

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

class Rain {
  final double volume_1h;
  final double volume_3h;

  Rain({
    required this.volume_1h,
    required this.volume_3h,
  });

  factory Rain.fromJson(Map<String, dynamic>? json) {
    return Rain(
      volume_1h: (json?["1h"] ?? 0) + .0,
      volume_3h: (json?["3h"] ?? 0) + .0,
    );
  }
}
