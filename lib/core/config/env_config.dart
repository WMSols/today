/// Runtime environment config loaded during app bootstrap.
abstract class EnvConfig {
  static String baseUrl = '';
  static String aiBaseUrl = '';
  static String aiApiKey = '';

  static Future<void> load() async {
    // Prefer compile-time values passed with --dart-define.
    baseUrl = const String.fromEnvironment('BASE_URL', defaultValue: '');
    aiBaseUrl = const String.fromEnvironment('AI_BASE_URL', defaultValue: '');
    aiApiKey = const String.fromEnvironment('AI_API_KEY', defaultValue: '');
  }
}
