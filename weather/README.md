# Weather app

Written by Gustav Kånåhols as part of the 1DV535 course at Linnaeus University.

## Building the application
This project uses the envied package to manage the environment variables.
To build the application you first need to generate the environment files.
To do this, place a .env file in the root directory with the following contents:
```
OPENWEATHERMAP_API_KEY=<your api key>
```
Then run the following commands:
```
flutter pub get
flutter pub run build_runner build
```
You can now build/run the application as usual (e.g. `flutter run`)
