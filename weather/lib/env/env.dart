import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: "OPENWEATHERMAP_API_KEY", obfuscate: true)
  // ignore: non_constant_identifier_names
  static String OPENWEATHERMAP_API_KEY = _Env.OPENWEATHERMAP_API_KEY;
}
