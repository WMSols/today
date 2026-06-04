import 'package:dio/dio.dart';
import 'package:today/core/config/env_config.dart';

class ZenQuoteService {
  const ZenQuoteService();

  static const _fallbackQuote = 'Stay consistent every day.';
  static const _fallbackAuthor = 'Unknown';

  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  Future<({String quote, String author})> fetchTodayQuote() async {
    if (EnvConfig.zenQuotesUrl.isEmpty) {
      return (quote: _fallbackQuote, author: _fallbackAuthor);
    }
    try {
      final response = await _dio.get<dynamic>(EnvConfig.zenQuotesUrl);
      final data = response.data;
      if (data is List &&
          data.isNotEmpty &&
          data.first is Map<String, dynamic>) {
        final item = data.first as Map<String, dynamic>;
        final quote = (item['q'] as String?) ?? _fallbackQuote;
        final author = (item['a'] as String?) ?? _fallbackAuthor;
        return (quote: quote, author: author);
      }
    } on DioException catch (_) {
      // Offline, timeout, or zenquotes.io unreachable — use fallback silently.
    } catch (_) {
      // Malformed response or other errors.
    }
    return (quote: _fallbackQuote, author: _fallbackAuthor);
  }
}
