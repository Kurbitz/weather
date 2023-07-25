import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:weather/weather.dart";

class WeatherAnimation extends StatelessWidget {
  const WeatherAnimation({
    super.key,
    required this.assetPath,
    required this.width,
    required this.height,
    this.text,
    this.fit,
  });
  final String assetPath;
  final double width;
  final double height;
  final Widget? text;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      direction: Axis.vertical,
      children: [
        Lottie.asset(
          assetPath,
          fit: fit,
          width: width,
          height: height,
        ),
        if (text != null) text!,
      ],
    );
  }

  factory WeatherAnimation.byWeatherData(
      WeatherData weatherData, double width, double height, bool isDay,
      [Widget? text, BoxFit? fit]) {
    var id = weatherData.weather.id;
    String assetPath;
    switch (id) {
      case 200:
      case 230:
      case 231:
      case 232:
      case 201:
      case 202:
        if (isDay) {
          assetPath = "assets/weather/fill/thunderstorms-day-rain.json";
        } else {
          assetPath = "assets/weather/fill/thunderstorms-night-rain.json";
        }
      case 211:
      case 210:
        if (isDay) {
          assetPath = "assets/weather/fill/thunderstorms-day.json";
        } else {
          assetPath = "assets/weather/fill/thunderstorms-night.json";
        }
      case 212:
      case 221:
        if (isDay) {
          assetPath = "assets/weather/fill/thunderstorms-day-extreme.json";
        } else {
          assetPath = "assets/weather/fill/thunderstorms-night-extreme.json";
        }
      case 300:
      case 301:
      case 302:
      case 310:
      case 311:
      case 312:
      case 321:
        if (isDay) {
          assetPath = "assets/weather/fill/partly-cloudy-day-drizzle.json";
        } else {
          assetPath = "assets/weather/fill/partly-cloudy-night-drizzle.json";
        }
      case 313:
      case 314:
      case 500:
      case 501:
      case 521:
      case 520:
        if (isDay) {
          assetPath = "assets/weather/fill/partly-cloudy-day-rain.json";
        } else {
          assetPath = "assets/weather/fill/partly-cloudy-night-rain.json";
        }
      case 502:
      case 503:
      case 522:
      case 504:
      case 531:
        if (isDay) {
          assetPath = "assets/weather/fill/extreme-day-rain.json";
        } else {
          assetPath = "assets/weather/fill/extreme-night-rain.json";
        }
      case 511:
        assetPath = "assets/weather/fill/extreme-sleet.json";
      case 600:
      case 620:
      case 601:
      case 621:
        if (isDay) {
          assetPath = "assets/weather/fill/partly-cloudy-day-snow.json";
        } else {
          assetPath = "assets/weather/fill/partly-cloudy-night-snow.json";
        }
      case 613:
      case 611:
      case 615:
      case 612:
      case 616:
        if (isDay) {
          assetPath = "assets/weather/fill/partly-cloudy-day-sleet.json";
        } else {
          assetPath = "assets/weather/fill/partly-cloudy-night-sleet.json";
        }
      case 602:
      case 622:
        assetPath = "assets/weather/fill/extreme-snow.json";
      case 701:
        assetPath = "assets/weather/fill/mist.json";
      case 711:
        assetPath = "assets/weather/fill/smoke.json";
      case 721:
        if (isDay) {
          assetPath = "assets/weather/fill/haze-day.json";
        } else {
          assetPath = "assets/weather/fill/haze-night.json";
        }
      case 731:
        assetPath = "assets/weather/fill/dust-wind.json";
      case 741:
        if (isDay) {
          assetPath = "assets/weather/fill/fog-day.json";
        } else {
          assetPath = "assets/weather/fill/fog-night.json";
        }
      case 751:
        if (isDay) {
          assetPath = "assets/weather/fill/dust-day.json";
        } else {
          assetPath = "assets/weather/fill/dust-night.json";
        }
      case 761:
        assetPath = "assets/weather/fill/dust.json";
      case 762:
        assetPath = "assets/weather/fill/smoke-particles.json";
      case 771:
        assetPath = "assets/weather/fill/wind.json";
      case 781:
        assetPath = "assets/weather/fill/tornado.json";
      case 800:
        if (isDay) {
          assetPath = "assets/weather/fill/clear-day.json";
        } else {
          assetPath = "assets/weather/fill/clear-night.json";
        }
      case 801:
      case 802:
      case 803:
        if (isDay) {
          assetPath = "assets/weather/fill/partly-cloudy-day.json";
        } else {
          assetPath = "assets/weather/fill/partly-cloudy-night.json";
        }
      case 804:
        if (isDay) {
          assetPath = "assets/weather/fill/overcast-day.json";
        } else {
          assetPath = "assets/weather/fill/overcast-night.json";
        }
      default:
        var time = DateTime.now().hour;
        if (time >= 0 && time < 3) {
          assetPath = "assets/weather/fill/time-night.json";
        } else if (time >= 3 && time < 6) {
          assetPath = "assets/weather/fill/time-late-night.json";
        } else if (time >= 6 && time < 9) {
          assetPath = "assets/weather/fill/time-morning.json";
        } else if (time >= 9 && time < 12) {
          assetPath = "assets/weather/fill/time-late-morning.json";
        } else if (time >= 12 && time < 15) {
          assetPath = "assets/weather/fill/time-afternoon.json";
        } else if (time >= 15 && time < 18) {
          assetPath = "assets/weather/fill/time-late-afternoon.json";
        } else if (time >= 18 && time < 21) {
          assetPath = "assets/weather/fill/time-evening.json";
        } else if (time >= 21 && time < 24) {
          assetPath = "assets/weather/fill/time-late-evening.json";
        } else {
          assetPath = "assets/weather/fill/not-available.json";
        }
    }
    return WeatherAnimation(
        assetPath: assetPath, width: width, height: height, text: text, fit: fit);
  }

  factory WeatherAnimation.byBeufort(int beufort, double width, double height,
      [Widget? text, BoxFit? fit]) {
    String assetPath;
    switch (beufort) {
      case 0:
        assetPath = "assets/weather/fill/wind-beaufort-0.json";

      case 1:
        assetPath = "assets/weather/fill/wind-beaufort-1.json";

      case 2:
        assetPath = "assets/weather/fill/wind-beaufort-2.json";

      case 3:
        assetPath = "assets/weather/fill/wind-beaufort-3.json";

      case 4:
        assetPath = "assets/weather/fill/wind-beaufort-4.json";

      case 5:
        assetPath = "assets/weather/fill/wind-beaufort-5.json";

      case 6:
        assetPath = "assets/weather/fill/wind-beaufort-6.json";

      case 7:
        assetPath = "assets/weather/fill/wind-beaufort-7.json";

      case 8:
        assetPath = "assets/weather/fill/wind-beaufort-8.json";

      case 9:
        assetPath = "assets/weather/fill/wind-beaufort-9.json";

      case 10:
        assetPath = "assets/weather/fill/wind-beaufort-10.json";

      case 11:
        assetPath = "assets/weather/fill/wind-beaufort-11.json";

      case 12:
        assetPath = "assets/weather/fill/wind-beaufort-12.json";

      default:
        assetPath = "assets/weather/fill/not-available.json";
    }
    return WeatherAnimation(
        assetPath: assetPath, width: width, height: height, text: text, fit: fit);
  }
}
