import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiDebugLogger {
  ApiDebugLogger._();

  static const _reset = '\x1B[0m';
  static const _green = '\x1B[32m';
  static const _red = '\x1B[31m';
  static const _cyan = '\x1B[36m';

  static void request(RequestOptions options) {
    if (!kDebugMode) return;
    final method = options.method.toUpperCase();
    debugPrint('$_cyan[API] → $method ${options.path}$_reset');
  }

  static void success(Response<dynamic> response) {
    if (!kDebugMode) return;
    final method = response.requestOptions.method.toUpperCase();
    debugPrint(
      '$_green[API] ✓ ${response.statusCode} $method ${response.requestOptions.path}$_reset',
    );
  }

  static void error(DioException err) {
    if (!kDebugMode) return;
    final request = err.requestOptions;
    final method = request.method.toUpperCase();
    final code = err.response?.statusCode?.toString() ?? 'NO_STATUS';
    final message = err.message ?? 'Unknown error';
    debugPrint('$_red[API] ✗ $code $method ${request.path} | $message$_reset');
  }
}
