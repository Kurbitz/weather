import 'package:weather/extentions.dart';
import 'package:weather/logic.dart';

/// Weather data model used to store weather data from the OpenWeatherMap API.
/// The data is stored in a class to make it easier to work with.
class WeatherData {
  final Weather weather;
  final Wind wind;
  final Rain rain;

  final double temperature;
  final double feelsLike;

  // Probability of precipitation is only available in the forecast data
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

  /// Returns the date of the weather data.
  DateTime get date => DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);

  /// Returns the time of the sunrise.
  DateTime get sunriseTime => DateTime.fromMillisecondsSinceEpoch(sunrise * 1000);

  /// Returns the time of the sunset.
  DateTime get sunsetTime => DateTime.fromMillisecondsSinceEpoch(sunset * 1000);

  /// Returns true if the weather data is during the day.
  bool get isDaytime => date.isAfterTimeOnly(sunriseTime) && date.isBeforeTimeOnly(sunsetTime);

  /// Creates a new WeatherData instance from a JSON object.
  /// The JSON structure is based on the OpenWeatherMap API
  /// data/2.5/weather endpoint.
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

  /// Creates a list of WeatherData instances from a JSON object.
  /// The JSON structure is based on the OpenWeatherMap API
  /// data/2.5/forecast endpoint.
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

/// Information about the weather.
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

/// Information about the location used to get the weather data.
class WeatherLocation {
  final String latitude;
  final String longitude;
  final String shortName;
  final String longName;

  // Rounding to 3 decimal points makes comparing locations easier since locations are not always
  // returned with the same precision. Not rounding can result in the same location being added
  // multiple times to the favorites list causing confusion for the user.
  // Ideally, some sort of fuzzy matching would be used to compare locations, but that is outside
  // the scope of this project.
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

  // Override the == operator to make it easier to compare WeatherLocation objects.
  // We only care about the latitude and longitude, not the name, since the name is subject to
  // change.
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

/// Information about the wind.
class Wind {
  final double speed;
  final int direction;

  // Converts degrees to cardinal direction
  // Based on:
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

  /// Returns the wind speed in Beaufort scale (0-12).
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

/// Information about the rain.
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
