import 'package:dio/dio.dart';
import 'package:today/core/auth/firebase_token_provider.dart';
import 'package:today/core/constants/api_constants.dart';
import 'package:today/core/network/api_debug_logger.dart';

/// Interceptor for TodAI API requests.
class ApiInterceptors extends Interceptor {
  ApiInterceptors(this._tokenProvider);

  final FirebaseTokenProvider _tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!ApiConstants.backendApiEnabled) {
      super.onRequest(options, handler);
      return;
    }
    ApiDebugLogger.request(options);
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    final token = await _tokenProvider.getBearerToken();
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
    if (ApiConstants.backendApiEnabled) {
      ApiDebugLogger.success(response);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (ApiConstants.backendApiEnabled) {
      ApiDebugLogger.error(err);
    }
    super.onError(err, handler);
  }
}
