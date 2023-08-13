// This file contains the definition of the Env class, which is used to import
// environment variables from a .env file. The .env file is not included in the
// repository, so you will need to create it yourself. The .env file should
// contain the following line:
//
// OPENWEATHERMAP_API_KEY=your_api_key
//
// To generate the .env.g.dart file, run the following command:
//
// flutter pub run build_runner build

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: ".env")
abstract class Env {
  // Use obfustace: true to obfuscate the API key in the generated file.
  @EnviedField(varName: "OPENWEATHERMAP_API_KEY", obfuscate: true)
  // ignore: non_constant_identifier_names
  static String OPENWEATHERMAP_API_KEY = _Env.OPENWEATHERMAP_API_KEY;
}
