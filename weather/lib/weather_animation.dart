import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:weather/weather.dart";

class WeatherAnimation extends StatelessWidget {
  const WeatherAnimation({
    super.key,
    required this.assetPath,
    required this.text,
    required this.width,
    required this.height,
  });
  final String assetPath;
  final Widget? text;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          assetPath,
          width: width,
          height: height,
        ),
        if (text != null)
          Center(
            child: text,
          ),
      ],
    );
  }

  factory WeatherAnimation.byWeatherData(
      WeatherData weatherData, double width, double height, bool isDay,
      [Widget? text]) {
    var id = weatherData.weather.id;

    switch (id) {
      case 200:
      case 230:
      case 231:
      case 232:
      case 201:
      case 202:
        if (isDay) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/thunderstorms-day-rain.json",
            text: text,
            width: width,
            height: height,
          );
        }
        return WeatherAnimation(
          assetPath: "assets/weather/fill/thunderstorms-night-rain.json",
          text: text,
          width: width,
          height: height,
        );

      case 211:
      case 210:
        if (isDay) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/thunderstorms-day.json",
            text: text,
            width: width,
            height: height,
          );
        }
        return WeatherAnimation(
          assetPath: "assets/weather/fill/thunderstorms-night.json",
          text: text,
          width: width,
          height: height,
        );
      case 212:
      case 221:
        if (isDay) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/thunderstorms-day-extreme.json",
            text: text,
            width: width,
            height: height,
          );
        }
        return WeatherAnimation(
          assetPath: "assets/weather/fill/thunderstorms-night-extreme.json",
          text: text,
          width: width,
          height: height,
        );

      case 300:
      case 301:
      case 302:
      case 310:
      case 311:
      case 312:
      case 321:
        if (isDay) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/partly-cloudy-day-drizzle.json",
            text: text,
            width: width,
            height: height,
          );
        }
        return WeatherAnimation(
          assetPath: "assets/weather/fill/partly-cloudy-night-drizzle.json",
          text: text,
          width: width,
          height: height,
        );

      case 313:
      case 314:
      case 500:
      case 501:
      case 521:
      case 520:
        if (isDay) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/partly-cloudy-day-rain.json",
            text: text,
            width: width,
            height: height,
          );
        }
        return WeatherAnimation(
          assetPath: "assets/weather/fill/partly-cloudy-night-rain.json",
          text: text,
          width: width,
          height: height,
        );
      case 502:
      case 503:
      case 522:
      case 504:
      case 531:
        if (isDay) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/extreme-day-rain.json",
            text: text,
            width: width,
            height: height,
          );
        }
        return WeatherAnimation(
          assetPath: "assets/weather/fill/extreme-night-rain.json",
          text: text,
          width: width,
          height: height,
        );
      case 511:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/extreme-sleet.json",
          text: text,
          width: width,
          height: height,
        );
      case 600:
      case 620:
      case 601:
      case 621:
        if (isDay) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/partly-cloudy-day-snow.json",
            text: text,
            width: width,
            height: height,
          );
        }
        return WeatherAnimation(
          assetPath: "assets/weather/fill/partly-cloudy-night-snow.json",
          text: text,
          width: width,
          height: height,
        );
      case 613:
      case 611:
      case 615:
      case 612:
      case 616:
        if (isDay) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/partly-cloudy-day-sleet.json",
            text: text,
            width: width,
            height: height,
          );
        }
        return WeatherAnimation(
          assetPath: "assets/weather/fill/partly-cloudy-night-sleet.json",
          text: text,
          width: width,
          height: height,
        );

      case 602:
      case 622:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/extreme-snow.json",
          text: text,
          width: width,
          height: height,
        );
      case 701:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/mist.json",
          text: text,
          width: width,
          height: height,
        );
      case 711:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/smoke.json",
          text: text,
          width: width,
          height: height,
        );
      case 721:
        if (isDay) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/haze-day.json",
            text: text,
            width: width,
            height: height,
          );
        }
        return WeatherAnimation(
          assetPath: "assets/weather/fill/haze-night.json",
          text: text,
          width: width,
          height: height,
        );
      case 731:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/dust-wind.json",
          text: text,
          width: width,
          height: height,
        );
      case 741:
        if (isDay) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/fog-day.json",
            text: text,
            width: width,
            height: height,
          );
        }
        return WeatherAnimation(
          assetPath: "assets/weather/fill/fog-night.json",
          text: text,
          width: width,
          height: height,
        );
      case 751:
        if (isDay) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/dust-day.json",
            text: text,
            width: width,
            height: height,
          );
        }
        return WeatherAnimation(
          assetPath: "assets/weather/fill/dust-night.json",
          text: text,
          width: width,
          height: height,
        );
      case 761:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/dust.json",
          text: text,
          width: width,
          height: height,
        );
      case 762:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/smoke-particles.json",
          text: text,
          width: width,
          height: height,
        );
      case 771:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/wind.json",
          text: text,
          width: width,
          height: height,
        );
      case 781:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/tornado.json",
          text: text,
          width: width,
          height: height,
        );
      case 800:
        if (isDay) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/clear-day.json",
            text: text,
            width: width,
            height: height,
          );
        }
        return WeatherAnimation(
          assetPath: "assets/weather/fill/clear-night.json",
          text: text,
          width: width,
          height: height,
        );

      case 801:
      case 802:
      case 803:
        if (isDay) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/partly-cloudy-day.json",
            text: text,
            width: width,
            height: height,
          );
        }
        return WeatherAnimation(
          assetPath: "assets/weather/fill/partly-cloudy-night.json",
          text: text,
          width: width,
          height: height,
        );

      case 804:
        if (isDay) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/overcast-day.json",
            text: text,
            width: width,
            height: height,
          );
        }
        return WeatherAnimation(
          assetPath: "assets/weather/fill/overcast-night.json",
          text: text,
          width: width,
          height: height,
        );
      default:
        var time = DateTime.now().hour;
        if (time >= 0 && time < 3) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/time-night.json",
            text: text,
            width: width,
            height: height,
          );
        } else if (time >= 3 && time < 6) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/time-late-night.json",
            text: text,
            width: width,
            height: height,
          );
        } else if (time >= 6 && time < 9) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/time-morning.json",
            text: text,
            width: width,
            height: height,
          );
        } else if (time >= 9 && time < 12) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/time-late-morning.json",
            text: text,
            width: width,
            height: height,
          );
        } else if (time >= 12 && time < 15) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/time-afternoon.json",
            text: text,
            width: width,
            height: height,
          );
        } else if (time >= 15 && time < 18) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/time-late-afternoon.json",
            text: text,
            width: width,
            height: height,
          );
        } else if (time >= 18 && time < 21) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/time-evening.json",
            text: text,
            width: width,
            height: height,
          );
        } else if (time >= 21 && time < 24) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/time-late-evening.json",
            text: text,
            width: width,
            height: height,
          );
        }
        return WeatherAnimation(
          assetPath: "assets/weather/fill/not-available.json",
          text: text,
          width: width,
          height: height,
        );
    }
  }
}
