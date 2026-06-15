import 'package:dio/dio.dart';

import 'package:today/core/auth/firebase_token_provider.dart';
import 'package:today/core/config/env_config.dart';
import 'package:today/core/constants/api_constants.dart';
import 'package:today/core/network/api_interceptors.dart';
import 'package:today/core/network/bootstrap_retry_interceptor.dart';

/// Singleton Dio instance with base URL and interceptors.
class DioClient {
  DioClient._();

  static Dio? _dio;

  static Dio get instance {
    if (_dio == null) {
      throw StateError(
        'DioClient not initialized. Call instanceWith from injection first.',
      );
    }
    return _dio!;
  }

  static Dio instanceWith({required FirebaseTokenProvider tokenProvider}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.baseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectTimeoutMs,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimeoutMs,
        ),
      ),
    );
    dio.interceptors.add(ApiInterceptors(tokenProvider));
    dio.interceptors.add(BootstrapRetryInterceptor(dio));
    _dio = dio;
    return dio;
  }
}
