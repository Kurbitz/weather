import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:weather/weather_animation.dart";

/// About page, displays information about the app.
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the page in a WillPopScope to handle the back button press.
    return WillPopScope(
      onWillPop: () async {
        context.go("/");
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("About"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go("/"),
          ),
        ),
        body: ListView(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Icon(
                      Icons.wb_sunny,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    "Weather",
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ],
              ),
            ),
            const ListTile(
              leading: Icon(Icons.info),
              title: Text("Version"),
              subtitle: Text("1.0.0"),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text("Created by"),
              subtitle: Text("github.com/Kurbitz"),
            ),
            const ListTile(
              leading: Icon(Icons.code),
              title: Text("Source code"),
              subtitle: Text("github.com/Kurbitz/weather"),
            ),
            const ListTile(
              leading: Icon(Icons.gavel),
              title: Text("License"),
              subtitle: Text("GNU GPLv3"),
            ),
            const ListTile(
              leading: Icon(Icons.attribution),
              title: Text("Attribution"),
            ),
            Column(
              children: [
                Image.asset(
                  "assets/openweather.png",
                  width: 200,
                ),
                Text(
                  "Weather data provided by OpenWeather",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            Column(
              children: [
                const WeatherAnimation(
                    assetPath: "assets/weather/fill/clear-day.json", width: 100, height: 100),
                Text(
                  "Meteocons by Bas Milius",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
