import 'package:dio/dio.dart';
import 'package:today/core/network/api_debug_logger.dart';
import 'package:today/core/storage/session_storage.dart';

/// Interceptor for API requests.
class ApiInterceptors extends Interceptor {
  ApiInterceptors(this._sessionStorage);

  final SessionStorage _sessionStorage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    ApiDebugLogger.request(options);
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    final token = await _sessionStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    ApiDebugLogger.success(response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ApiDebugLogger.error(err);
    super.onError(err, handler);
  }
}
