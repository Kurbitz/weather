import 'package:flutter/material.dart';
import 'package:weather/provider.dart';
import 'package:provider/provider.dart';
import 'package:weather/routes/home.dart';
import 'package:weather/routes/about.dart';
import 'package:go_router/go_router.dart';

// The GoRouter is used to handle navigation between pages.
// It's probably overkill in this app since there are only two pages, but I wanted to try it out.
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WeatherPage(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutPage(),
    ),
  ],
);

// The entry point of the app.
void main() {
  runApp(
    // The ChangeNotifierProvider is used to provide the WeatherProvider to the entire app.
    ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: const WeatherApp(),
    ),
  );
}

/// The main widget of the app.
class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The MaterialApp.router is used to provide the GoRouter to the entire app.
    // The themeMode is set to system to allow the app to change between light and dark mode
    // depending on the device's settings.
    // Minimal theme data is provided since the app uses Material 3.
    return MaterialApp.router(
      title: 'Weather',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
