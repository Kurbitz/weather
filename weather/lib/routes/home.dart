import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:weather/provider.dart";
import "package:provider/provider.dart";
import "package:lottie/lottie.dart";

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    var location = context.select((WeatherProvider p) => p.location);
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
      body: const DefaultTabController(
        length: 2,
        child: Flex(
          direction: Axis.vertical,
          children: [
            TabBar(
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
                  Weather(),
                  Forecast(),
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
  });

  @override
  Widget build(BuildContext context) {
    var lastUpdated = context.select((WeatherProvider p) => p.lastUpdatedString);
    return Expanded(
      child: RefreshIndicator(
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
                  const Row(
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
                                  "20C°",
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Feels like 20C°",
                                  style: TextStyle(
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
                        child: WeatherAnimation(
                          assetPath: "assets/weather/fill/clear-day.json",
                          title: "Sunny",
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text(
                          "The whole day it's pretty much gonna be hot.",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
