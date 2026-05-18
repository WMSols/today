import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:today/core/constants/api_constants.dart';
import 'package:today/core/network/api_stubs.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  // ignore: unused_field
  final Dio _dio;

  String _usernameFromFirebase() {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }
    return 'guest';
  }

  Future<Map<String, dynamic>> signup({
    required String username,
    required String password,
    String? timezone,
  }) async {
    if (!ApiConstants.backendApiEnabled) {
      return ApiStubs.authSession(username: username);
    }
    // final response = await _dio.post<Map<String, dynamic>>(
    //   '/auth/signup',
    //   data: {
    //     'username': username,
    //     'password': password,
    //     if (timezone != null && timezone.isNotEmpty) 'timezone': timezone,
    //   },
    // );
    // return response.data ?? <String, dynamic>{};
    return ApiStubs.authSession(username: username);
  }

  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    if (!ApiConstants.backendApiEnabled) {
      return ApiStubs.authSession(username: username);
    }
    // final response = await _dio.post<Map<String, dynamic>>(
    //   '/auth/login',
    //   data: {'username': username, 'password': password},
    // );
    // return response.data ?? <String, dynamic>{};
    return ApiStubs.authSession(username: username);
  }

  Future<Map<String, dynamic>> exchangeFirebaseSession({
    required String idToken,
    String? timezone,
  }) async {
    if (!ApiConstants.backendApiEnabled) {
      return ApiStubs.authSession(
        accessToken: idToken,
        username: _usernameFromFirebase(),
      );
    }
    // final response = await _dio.post<Map<String, dynamic>>(
    //   '/auth/firebase',
    //   data: {
    //     'id_token': idToken,
    //     if (timezone != null && timezone.isNotEmpty) 'timezone': timezone,
    //   },
    // );
    // return response.data ?? <String, dynamic>{};
    return ApiStubs.authSession(
      accessToken: idToken,
      username: _usernameFromFirebase(),
    );
  }

  Future<Map<String, dynamic>> getMe() async {
    if (!ApiConstants.backendApiEnabled) {
      return ApiStubs.me(username: _usernameFromFirebase());
    }
    // final response = await _dio.get<Map<String, dynamic>>('/me');
    // return response.data ?? <String, dynamic>{};
    return ApiStubs.me(username: _usernameFromFirebase());
  }
}
