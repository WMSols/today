import 'package:dio/dio.dart';

class ZenQuoteService {
  const ZenQuoteService();

  Future<({String quote, String author})> fetchTodayQuote() async {
    final response = await Dio().get('https://zenquotes.io/api/today');
    final data = response.data;
    if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
      final item = data.first as Map<String, dynamic>;
      final quote = (item['q'] as String?) ?? 'Stay consistent every day.';
      final author = (item['a'] as String?) ?? 'Unknown';
      return (quote: quote, author: author);
    }
    return (quote: 'Stay consistent every day.', author: 'Unknown');
  }
}

