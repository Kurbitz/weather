import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:weather/provider.dart";
import "package:provider/provider.dart";
import "package:weather/weather.dart";
import "package:weather/weather_animation.dart";

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    var location = context.select((WeatherProvider p) => p.location);
    var weatherData = context.select((WeatherProvider p) => p.weatherData);
    return Scaffold(
      appBar: AppBar(
        title: Text(location),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.go("/search"),
          )
        ],
      ),
      drawer: Drawer(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Icon(
                      Icons.wb_sunny,
                      size: 50,
                    ),
                  ),
                  Text(
                    "Weather",
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text("About"),
              leading: const Icon(Icons.info),
              onTap: () => context.go("/about"),
            ),
          ],
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Flex(
          direction: Axis.vertical,
          children: [
            const TabBar(
              tabs: [
                Tab(
                  text: "Weather",
                ),
                Tab(
                  text: "Forecast",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Weather(
                    weatherData: weatherData,
                  ),
                  const Forecast(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Forecast extends StatelessWidget {
  const Forecast({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class Weather extends StatelessWidget {
  const Weather({
    super.key,
    required this.weatherData,
  });

  final WeatherData? weatherData;

  @override
  Widget build(BuildContext context) {
    var lastUpdated = context.select((WeatherProvider p) => p.lastUpdatedString);
    var isDaytime = context.select((WeatherProvider p) => p.isDaytime);

    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(
          const Duration(seconds: 1),
          () {
            context.read<WeatherProvider>().update();
            return;
          },
        );
      },
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Text(
                        lastUpdated,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Column(
                            children: [
                              Text(
                                "${weatherData?.temperature.round() ?? ""}C°",
                                style: const TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Feels like ${weatherData?.feelsLike.round() ?? ""}C°",
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: weatherData == null
                          ? const CircularProgressIndicator()
                          : WeatherAnimation.byWeatherData(weatherData!, 120, 120, isDaytime),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
