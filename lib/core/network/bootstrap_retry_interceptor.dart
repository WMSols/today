import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:today/core/constants/api_constants.dart';
import 'package:today/domain/repositories/auth_repository.dart';

/// Retries authenticated requests after bootstrapping when the backend returns 404.
class BootstrapRetryInterceptor extends Interceptor {
  BootstrapRetryInterceptor(this._dio);

  final Dio _dio;
  static const _retryKey = 'bootstrap_retry_attempted';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!ApiConstants.backendApiEnabled ||
        err.response?.statusCode != 404 ||
        err.requestOptions.extra[_retryKey] == true ||
        _isPublicPath(err.requestOptions.path) ||
        _isBootstrapPath(err.requestOptions.path)) {
      return handler.next(err);
    }

    final hadAuth = err.requestOptions.headers.containsKey('Authorization');
    if (!hadAuth) {
      return handler.next(err);
    }

    if (!Get.isRegistered<AuthRepository>()) {
      return handler.next(err);
    }

    try {
      await Get.find<AuthRepository>().bootstrapUser();
    } catch (_) {
      return handler.next(err);
    }

    final options = err.requestOptions;
    options.extra[_retryKey] = true;

    try {
      final response = await _dio.fetch<dynamic>(options);
      return handler.resolve(response);
    } on DioException catch (retryError) {
      return handler.next(retryError);
    }
  }

  bool _isPublicPath(String path) {
    return path.contains(ApiConstants.healthPath) ||
        path.contains(ApiConstants.authConfigPath);
  }

  bool _isBootstrapPath(String path) {
    return path.contains(ApiConstants.authBootstrapPath);
  }
}
