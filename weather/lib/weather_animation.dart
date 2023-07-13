import "package:flutter/material.dart";
import "package:lottie/lottie.dart";
import "package:weather/weather.dart";

class WeatherAnimation extends StatelessWidget {
  WeatherAnimation({
    super.key,
    required this.assetPath,
    required this.title,
    required this.width,
    required this.height,
  });
  final String assetPath;
  final String title;
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
        Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }

  // TODO: Pick the right animation for the weather
  factory WeatherAnimation.byWeatherData(
    WeatherData weatherData,
    double width,
    double height,
    bool isDay,
  ) {
    var id = weatherData.weather.id;
    var title = weatherData.weather.main;
    switch (id) {
      case 200:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 201:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 202:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 210:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 211:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 212:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 221:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 230:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 231:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 232:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 300:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 301:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 302:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 310:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 311:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 312:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 313:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 314:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 321:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 500:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 501:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 502:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 503:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 504:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 511:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 520:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 521:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 522:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 531:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 600:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 601:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 602:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 611:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 612:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 613:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 615:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 616:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 620:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 621:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 622:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 701:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 711:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 721:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 731:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 741:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 751:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 761:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 762:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 771:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 781:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 800:
        if (isDay) {
          return WeatherAnimation(
            assetPath: "assets/weather/fill/clear-day.json",
            title: title,
            width: width,
            height: height,
          );
        }
        return WeatherAnimation(
          assetPath: "assets/weather/fill/clear-night.json",
          title: title,
          width: width,
          height: height,
        );

      case 801:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/clear-day.json",
          title: title,
          width: width,
          height: height,
        );
      case 802:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 803:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      case 804:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
      default:
        return WeatherAnimation(
          assetPath: "assets/weather/fill/rain.json",
          title: title,
          width: width,
          height: height,
        );
    }
  }
}
