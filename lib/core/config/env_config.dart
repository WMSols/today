import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Runtime environment config loaded during app bootstrap.
abstract class EnvConfig {
  static String baseUrl = '';
  static String zenQuotesUrl = '';

  static Future<void> load() async {
    if (!dotenv.isInitialized) {
      await dotenv.load(fileName: '.env');
    }

    baseUrl = dotenv.env['BASE_URL'] ?? '';
    zenQuotesUrl = dotenv.env['ZEN_QUOTES_URL'] ?? '';
  }
}
