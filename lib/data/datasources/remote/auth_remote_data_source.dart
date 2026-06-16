import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:today/core/constants/api_constants.dart';
import 'package:today/core/network/api_stubs.dart';

class AuthRemoteDataSource {
  const AuthRemoteDataSource(this._dio);

  final Dio _dio;

  String _displayNameFromFirebase() {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }
    final email = user?.email;
    if (email != null && email.contains('@')) {
      return email.split('@').first;
    }
    return 'Guest';
  }

  String _emailFromFirebase() {
    return FirebaseAuth.instance.currentUser?.email?.trim() ?? '';
  }

  Future<Map<String, dynamic>> checkHealth() async {
    if (!ApiConstants.backendApiEnabled) {
      return ApiStubs.health();
    }
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.healthPath,
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> getAuthConfig() async {
    if (!ApiConstants.backendApiEnabled) {
      return ApiStubs.authConfig();
    }
    final response = await _dio.get<Map<String, dynamic>>(
      ApiConstants.authConfigPath,
    );
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> bootstrapUser() async {
    if (!ApiConstants.backendApiEnabled) {
      return ApiStubs.bootstrap(
        displayName: _displayNameFromFirebase(),
        email: _emailFromFirebase().isEmpty ? null : _emailFromFirebase(),
      );
    }
    final response = await _dio.post<Map<String, dynamic>>(
      ApiConstants.authBootstrapPath,
    );
    return response.data ?? <String, dynamic>{};
  }
}
