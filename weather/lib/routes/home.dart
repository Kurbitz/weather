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
    // Using a FutureBuilder allows us to wait for the WeatherProvider to be
    // ready before building the UI and to handle errors.
    return FutureBuilder(
        future: Future.value(context.select((WeatherProvider p) => p.onReady)),
        builder: (context, snapshot) {
          // If the snapshot is not ready, display a loading indicator.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // If the snapshot has an error, display an error message.
          // TODO: Read up on the Android guidelines for error messages, especially
          // regarding how to communicate permission errors.
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Error",
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      snapshot.error.toString(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.error,
                          ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onError,
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () {
                      // This will trigger a reload of the WeatherProvider, which creates
                      // a new Completer and Future.
                      context.read<WeatherProvider>().reload();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          // If the snapshot is ready, build the UI.
          final location = context.select((WeatherProvider p) => p.location)!;
          final weatherData = context.select((WeatherProvider p) => p.currentWeather)!;
          final weatherForecast = context.select((WeatherProvider p) => p.weatherForecast)!;
          final locationIsFavorite = context.select((WeatherProvider p) => p.locationIsFavorite);
          final favorites = context.select((WeatherProvider p) => p.favorites);

          return Scaffold(
            appBar: AppBar(
              title: Flex(
                direction: Axis.horizontal,
                children: [
                  Flexible(
                    child: Text(
                      location.shortName, // Display the name of the current location in the appbar.
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
                // Icon button to toggle the favorite status of the current location.
                IconButton(
                  tooltip: locationIsFavorite ? "Remove from favorites" : "Add to favorites",
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
                // GPS icon button to update the current location.
                IconButton(
                  icon: const Icon(Icons.my_location),
                  tooltip: "Get current location",
                  onPressed: () => {
                    // Update the location and show a SnackBar giving feedback on whether the
                    // update was successful or not.
                    Provider.of<WeatherProvider>(context, listen: false).updateLocation().then(
                      (_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: const Text("Location updated"),
                              backgroundColor: Theme.of(context).colorScheme.primary),
                        );
                      },
                    ).onError((error, stackTrace) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }),
                  },
                ),
              ],
            ),
            drawer: Drawer(
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              child: WeatherDrawer(
                favorites: favorites,
                currentLocation: location,
              ),
            ),
            // Display the content in a tab controller with 2 tabs, one for the current weather
            // and one for the 5-day forecast.
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
                        Forecast(
                          weatherForecast: weatherForecast,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

/// A drawer that displays a list of favorite locations [favorites].
class WeatherDrawer extends StatelessWidget {
  const WeatherDrawer({
    super.key,
    required this.favorites,
    required this.currentLocation,
  });

  /// The list of favorite locations.
  final List<WeatherLocation> favorites;

  /// The current location, used to highlight the current location in the list of favorites.
  final WeatherLocation currentLocation;

  @override
  Widget build(BuildContext context) {
    // Wrapping the widget in a SafeArea prevents the drawer from being drawn behind the status bar.
    return SafeArea(
      child: ListView(
        children: [
          DrawerHeader(
            child: FittedBox(
              fit: BoxFit.fitWidth,
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
          ),
          // Show the current location at the top of the list.
          ListTile(
            title: Text(
              "Current location",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(currentLocation.longName),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Favorites",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          // Show the list of all saved favorites.
          Wrap(
            children: [
              ...favorites
                  .map(
                    (wl) => ListTile(
                      title: Text(
                        wl.shortName,
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: currentLocation.shortName == wl.shortName
                                  ? Theme.of(context).colorScheme.onPrimaryContainer
                                  : null,
                            ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        tooltip: "Remove from favorites",
                        onPressed: () {
                          context.read<WeatherProvider>().removeFavorite(wl);
                        },
                      ),
                      tileColor: currentLocation.shortName == wl.shortName
                          ? Theme.of(context).colorScheme.primaryContainer
                          : null,
                      subtitle: Text(wl.longName,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                color: currentLocation.shortName == wl.shortName
                                    ? Theme.of(context).colorScheme.onPrimaryContainer
                                    : null,
                              )),
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
          // Show a button to clear all favorites.
          ListTile(
            title: const Text("Clear"),
            leading: const Icon(Icons.clear),
            onTap: () {
              showDialog(
                context: context,
                // Show a confirmation dialog before clearing all favorites.
                builder: (context) => AlertDialog(
                  title: const Text("Clear favorites"),
                  content: const Text("Are you sure you want to clear all favorites?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<WeatherProvider>().clearFavorites();
                        Navigator.pop(context);
                      },
                      child: const Text("Clear"),
                    ),
                  ],
                ),
              );
            },
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
      ),
    );
  }
}

/// The current weather.
/// Displays the current weather and some details about the weather in [weatherData].
// Used as the first tab in the WeatherPage.
class Weather extends StatelessWidget {
  const Weather({
    super.key,
    required this.weatherData,
  });

  final WeatherData weatherData;

  @override
  Widget build(BuildContext context) {
    var lastUpdated = context.select((WeatherProvider p) => p.lastUpdatedString);

    // Wrapping the content in a RefreshIndicator allows the user to refresh the weather
    // by pulling down on the screen.
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(
          const Duration(seconds: 1),
          () {
            context.read<WeatherProvider>().updateWeather().onError(
              (error, stackTrace) {
                // Show a SnackBar if the update fails.
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Error updating weather"),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              },
            );
          },
        );
      },
      child: ListView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(8.0),
        children: [
          Row(
            // Last updated
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
          Column(
            children: [
              Row(
                // Temperature and weather animation
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          "${weatherData.temperature.round()}C°",
                          softWrap: false,
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                fontSize: 72,
                              ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Feels like ${weatherData.feelsLike.round()}C°",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: WeatherAnimation.byWeatherData(
                      weatherData,
                      120,
                      120,
                      weatherData.isDaytime,
                      Text(
                        weatherData.weather.description.capitalize(),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      BoxFit.scaleDown,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Details(weatherData: weatherData),
              const SizedBox(height: 20),
              SunInfo(
                weatherData: weatherData,
                iconWidth: 100,
                iconHeight: 100,
                direction: Axis.horizontal,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Details about the current weather in [weatherData].
/// Displays the wind speed, wind direction, rain volume, probability of precipitation,
/// Beaufort wind force, humidity and pressure. The last 3 are displayed as animated icons.
/// [use3hRain] determines whether to use the 3h rain volume or the 1h rain volume. The 3h rain
/// volume is only available in the 5-day forecast.
class Details extends StatelessWidget {
  const Details({
    super.key,
    required this.weatherData,
    this.use3hRain = false,
  });

  /// The weather data to display details about.
  final WeatherData weatherData;

  /// Use 3h rain volume instead of 1h rain volume.
  final bool use3hRain;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Text(
                "Details",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: RichText(
                    textAlign: TextAlign.start,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${weatherData.wind.speed} m/s",
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                        TextSpan(
                            text: " winds from ${weatherData.wind.cardinalDirection}",
                            style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  "${use3hRain ? weatherData.rain.volume_3h.toStringAsPrecision(1) : weatherData.rain.volume_1h.toStringAsPrecision(1)} mm",
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  ),
                            ),
                            TextSpan(
                              text: use3hRain ? " of rain" : " of rain in the last hour",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      if (weatherData.probabilityOfPrecipitation != null)
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${(weatherData.probabilityOfPrecipitation! * 100).round()}%",
                                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                    ),
                              ),
                              TextSpan(
                                text: " chance of rain",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              direction: Axis.horizontal,
              children: [
                WeatherAnimation.byBeufort(
                  weatherData.wind.beaufort,
                  100,
                  100,
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${weatherData.wind.beaufort}",
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                        TextSpan(
                          text: "\nBeaufort",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                WeatherAnimation(
                  assetPath: "assets/weather/fill/humidity.json",
                  width: 100,
                  height: 100,
                  text: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${weatherData.humidity}%",
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                        TextSpan(
                          text: "\nHumidity",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                WeatherAnimation(
                  assetPath: weatherData.pressure > 1013
                      ? "assets/weather/fill/pressure-low.json"
                      : "assets/weather/fill/pressure-low.json",
                  width: 100,
                  height: 100,
                  text: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${weatherData.pressure}",
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                        ),
                        TextSpan(
                          text: "\nPressure",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The 5-day forecast, displayed as a list of [DailyForecast]s.
/// Each [DailyForecast] displays the weather for a single day.
/// The [weatherForecast] is a list of lists of [WeatherData]s, where each inner list
/// contains the weather data for a single day.
class Forecast extends StatelessWidget {
  const Forecast({
    super.key,
    required this.weatherForecast,
  });

  // TODO: Use a better data structure for weatherForecast.
  /// The weather forecast, a list of lists of [WeatherData]s.
  final List<List<WeatherData>> weatherForecast;

  @override
  Widget build(BuildContext context) {
    // Wrapping the content in a RefreshIndicator allows the user to refresh the weather
    // by pulling down on the screen.
    return RefreshIndicator(
      onRefresh: () {
        return Future.delayed(
          const Duration(seconds: 1),
          () {
            context.read<WeatherProvider>().updateWeather().onError(
              (error, stackTrace) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Error updating weather"),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              },
            );
          },
        );
      },
      child: ListView.builder(
        itemCount: weatherForecast.length,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(8.0),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: DailyForecast(
            dailyData: weatherForecast[index],
          ),
        ),
      ),
    );
  }
}

/// A single day in the 5-day forecast.
/// Displays the weather for a single day in [dailyData].
class DailyForecast extends StatelessWidget {
  const DailyForecast({
    super.key,
    required this.dailyData,
  });

  final List<WeatherData> dailyData;

  @override
  Widget build(BuildContext context) {
    // Determine the name of the day to display.
    // If the date is today or tomorrow, display "Today" or "Tomorrow" instead of the day name.
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
            // Display the day name.
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  dayName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            // Display the weather for each 3-hour interval in the day.
            // Using a ListView.separated allows us to add dividers between the items.
            ListView.separated(
              itemCount: dailyData.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) => const Divider(height: 0),
              itemBuilder: (context, index) {
                final weather = dailyData[index];
                return ExpansionTile(
                  title: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${weather.temperature.round()}C°",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                      ),
                      Text(
                        "${(weather.probabilityOfPrecipitation! * 100).round()}%",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                      ),
                    ],
                  ),
                  subtitle: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          weather.weather.description.capitalize(),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      Text(
                        "${weather.rain.volume_3h.toStringAsPrecision(1)} mm",
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ],
                  ),
                  leading: Text(timestampToHourSpan(weather.timeStamp, 3),
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          )),
                  trailing: WeatherAnimation.byWeatherData(
                    weather,
                    50,
                    50,
                    weather.isDaytime,
                  ),
                  tilePadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Details(
                        weatherData: weather,
                        use3hRain: true,
                      ),
                    ),
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

/// Displays the sunrise and sunset times in [weatherData].
class SunInfo extends StatelessWidget {
  const SunInfo({
    super.key,
    required this.weatherData,
    required this.iconWidth,
    required this.iconHeight,
    this.direction = Axis.vertical,
    this.padding = const EdgeInsets.all(8.0),
  });

  /// The weather data to display sunrise and sunset times for.
  final WeatherData weatherData;

  /// The width of the weather animation icons.
  final double iconWidth;

  /// The height of the weather animation icons.
  final double iconHeight;

  /// The direction of the layout. Defaults to vertical.
  final Axis direction;

  /// The padding around the content.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    // Display the sunrise and sunset times, changing the layout depending on the direction.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.25),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          children: [
            Center(
              child: Text(
                "Sunrise and sunset",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: Flex(
                    direction: direction,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WeatherAnimation(
                        assetPath: "assets/weather/fill/sunrise.json",
                        width: iconWidth,
                        height: iconHeight,
                      ),
                      Text(
                        DateFormat("HH:mm").format(weatherData.sunriseTime),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Flex(
                    direction: direction,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WeatherAnimation(
                        assetPath: "assets/weather/fill/sunset.json",
                        width: iconWidth,
                        height: iconHeight,
                      ),
                      Text(
                        DateFormat("HH:mm").format(weatherData.sunsetTime),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
