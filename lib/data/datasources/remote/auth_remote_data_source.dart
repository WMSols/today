import 'package:dio/dio.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> signup({
    required String username,
    required String password,
    String? timezone,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/signup',
      data: {
        'username': username,
        'password': password,
        if (timezone != null && timezone.isNotEmpty) 'timezone': timezone,
      },
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'username': username, 'password': password},
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> exchangeFirebaseSession({
    required String idToken,
    String? timezone,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/firebase',
      data: {
        'id_token': idToken,
        if (timezone != null && timezone.isNotEmpty) 'timezone': timezone,
      },
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> getMe() async {
    final response = await _dio.get<Map<String, dynamic>>('/me');
    return response.data ?? <String, dynamic>{};
  }
}
