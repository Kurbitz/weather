import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:intl/intl.dart";
import "package:weather/extentions.dart";
import "package:weather/logic.dart";
import "package:weather/provider.dart";
import "package:provider/provider.dart";
import "package:weather/weather.dart";
import "package:weather/weather_animation.dart";

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    var location = context.select((WeatherProvider p) => p.location.shortName);
    var weatherData = context.select((WeatherProvider p) => p.currentWeather);
    var weatherForecast = context.select((WeatherProvider p) => p.weatherForecast);
    var locationIsFavorite = context.select((WeatherProvider p) => p.locationIsFavorite);
    var favorites = context.select((WeatherProvider p) => p.favorites);
    return Scaffold(
      appBar: AppBar(
        title: Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              child: Text(
                location,
                style: const TextStyle(
                  fontSize: 22,
                ),
                overflow: TextOverflow.fade,
                softWrap: true,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: locationIsFavorite
                ? Icon(
                    Icons.favorite,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : const Icon(Icons.favorite_border),
            onPressed: () {
              context.read<WeatherProvider>().toggleFavorite();
            },
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: () => {
              Provider.of<WeatherProvider>(context, listen: false).updateLocation().then(
                (updateSucceeded) {
                  if (updateSucceeded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: const Text("Location updated"),
                          backgroundColor: Theme.of(context).colorScheme.primary),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Location update failed"),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                },
              ),
            },
          ),
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
                  Forecast(weatherForecast: weatherForecast),
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
        ListTile(
          title: Text(
            "Current location",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            context.select((WeatherProvider p) => p.location.longName),
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
      child: FutureBuilder(
        future: Future.value(weatherData),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Error"),
                  TextButton(
                    onPressed: () {
                      context.read<WeatherProvider>().update();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return ListView(
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8.0),
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text(
                          lastUpdated,
                          style: Theme.of(context).textTheme.titleMedium,
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
                                  "${weatherData!.temperature.round()}C°",
                                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                ),
                                Text(
                                  "Feels like ${weatherData!.feelsLike.round()}C°",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: WeatherAnimation.byWeatherData(
                          weatherData!,
                          120,
                          120,
                          isDaytime,
                          Text(
                            weatherData!.weather.main,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.transparent, height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      WeatherAnimation.byBeufort(
                        metersPerSecondToBeaufort(weatherData!.wind.speed),
                        100,
                        100,
                        Text("${metersPerSecondToBeaufort(weatherData!.wind.speed)} BFT",
                            style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      Text(
                        "${weatherData!.wind.speed.round()} m/s from ${weatherData!.wind.cardinalDirection}",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  const Divider(color: Colors.transparent, height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      WeatherAnimation(
                        assetPath: "assets/weather/fill/humidity.json",
                        width: 100,
                        height: 100,
                        text: Text("${weatherData!.humidity}% humidity",
                            style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      WeatherAnimation(
                        assetPath: weatherData!.pressure > 1013
                            ? "assets/weather/fill/pressure-high.json"
                            : "assets/weather/fill/pressure-low.json",
                        width: 100,
                        height: 100,
                        text: Text(
                          "${weatherData!.pressure} hPa",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class Forecast extends StatelessWidget {
  const Forecast({
    super.key,
    required this.weatherForecast,
  });

  final List<List<WeatherData>>? weatherForecast;

  @override
  Widget build(BuildContext context) {
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
      child: FutureBuilder(
        future: Future.value(weatherForecast),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Error"),
                  TextButton(
                    onPressed: () {
                      context.read<WeatherProvider>().update();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: weatherForecast!.length,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(8.0),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: DailyForecast(
                dailyData: weatherForecast![index],
              ),
            ),
          );
        },
      ),
    );
  }
}

class DailyForecast extends StatelessWidget {
  const DailyForecast({
    super.key,
    required this.dailyData,
  });

  final List<WeatherData> dailyData;

  @override
  Widget build(BuildContext context) {
    final date = dailyData[0].date;
    final now = DateTime.now();
    String dayName;
    if (date.isSameDate(now)) {
      dayName = "Today ${DateFormat("d, MMMM").format(date)}";
    } else if (now.add(const Duration(days: 1)).isSameDate(date)) {
      dayName = "Tomorrow ${DateFormat("d, MMMM").format(date)}";
    } else {
      dayName = DateFormat("EEEE d, MMMM").format(date);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  dayName,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            ListView.separated(
              itemCount: dailyData.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final weather = dailyData[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      timestampToHourSpan(weather.timeStamp, 3),
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(width: 10),
                    WeatherAnimation.byWeatherData(weather, 50, 50, true),
                    const SizedBox(width: 10),
                    Text(
                      "${weather.temperature.round()}C°",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      weather.weather.description.capitalize(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
