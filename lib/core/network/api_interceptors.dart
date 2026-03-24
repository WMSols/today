import 'package:dio/dio.dart';

/// Interceptor for API requests.
class ApiInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept'] = 'application/json';
    super.onRequest(options, handler);
  }
}
