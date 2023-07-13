import "package:flutter/material.dart";
import "package:lottie/lottie.dart";

class WeatherAnimation extends StatelessWidget {
  const WeatherAnimation({
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
}
