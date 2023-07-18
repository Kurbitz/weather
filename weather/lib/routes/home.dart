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
    var location = context.select((WeatherProvider p) => p.currentWeatherLocation.shortName);
    var weatherData = context.select((WeatherProvider p) => p.weatherData);
    var locationIsFavorite = context.select((WeatherProvider p) => p.locationIsFavorite);
    var favorites = context.select((WeatherProvider p) => p.favorites);
    return Scaffold(
      appBar: AppBar(
        title: Text(location),
        actions: [
          IconButton(
            icon: Icon(locationIsFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              context.read<WeatherProvider>().toggleFavorite();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.go("/search"),
          )
        ],
      ),
      drawer: Drawer(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: WeatherDrawer(
          favorites: favorites,
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

class WeatherDrawer extends StatelessWidget {
  const WeatherDrawer({
    super.key,
    required this.favorites,
  });

  final List<WeatherLocation> favorites;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DrawerHeader(
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
              const Text(
                "Weather",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Favorites",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        Wrap(
          children: [
            ...favorites
                .map(
                  (wl) => ListTile(
                    title: Text(
                      wl.shortName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: () {
                        context.read<WeatherProvider>().removeFavorite(wl);
                      },
                    ),
                    tileColor:
                        context.select((WeatherProvider p) => p.location.shortName) == wl.shortName
                            ? Theme.of(context).colorScheme.primaryContainer
                            : null,
                    subtitle: Text(wl.longName),
                    onTap: () {
                      context.read<WeatherProvider>().setWeatherLocation(wl);
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ],
        ),
        const Divider(),
        ListTile(
          title: const Text("Clear"),
          leading: const Icon(Icons.clear),
          onTap: () => context.read<WeatherProvider>().clearFavorites(),
        ),
        ListTile(
          title: const Text("About"),
          leading: const Icon(Icons.info),
          onTap: () => context.go("/about"),
        ),
        const Divider(
          color: Colors.transparent,
        ),
      ],
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
