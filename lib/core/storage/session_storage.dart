import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:today/core/constants/storage_keys.dart';
import 'package:today/data/models/auth_bootstrap_model.dart';

class SessionStorage {
  static const String _rememberMeKey = 'remember_me';

  Future<void> saveRememberMePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, value);
  }

  Future<bool> getRememberMePreference({bool defaultValue = true}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? defaultValue;
  }

  Future<void> saveBootstrapUser(AuthBootstrapModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.bootstrapUser, jsonEncode(user.toJson()));
  }

  Future<Map<String, dynamic>?> getBootstrapUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(StorageKeys.bootstrapUser);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return null;
  }

  Future<void> clearBootstrapUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.bootstrapUser);
  }

  Future<void> saveLoginCredentials({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.savedLoginEmail, email);
    await prefs.setString(StorageKeys.savedLoginPassword, password);
  }

  Future<({String? email, String? password})> getLoginCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    return (
      email: prefs.getString(StorageKeys.savedLoginEmail),
      password: prefs.getString(StorageKeys.savedLoginPassword),
    );
  }

  Future<void> clearLoginCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.savedLoginEmail);
    await prefs.remove(StorageKeys.savedLoginPassword);
  }

  Future<void> clearSession() async {
    await clearBootstrapUser();
  }
}
