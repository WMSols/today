import 'package:shared_preferences/shared_preferences.dart';
import 'package:today/core/constants/storage_keys.dart';

class SessionStorage {
  static const String _accessTokenKey = 'access_token';
  static const String _rememberMeKey = 'remember_me';
  String? _runtimeAccessToken;

  Future<void> saveRememberMePreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, value);
  }

  Future<bool> getRememberMePreference({bool defaultValue = true}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? defaultValue;
  }

  Future<void> saveAccessToken(String token, {bool persist = true}) async {
    _runtimeAccessToken = token;
    final prefs = await SharedPreferences.getInstance();
    if (persist) {
      await prefs.setString(_accessTokenKey, token);
      return;
    }
    await prefs.remove(_accessTokenKey);
  }

  Future<String?> getAccessToken() async {
    if (_runtimeAccessToken != null && _runtimeAccessToken!.isNotEmpty) {
      return _runtimeAccessToken;
    }
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_accessTokenKey);
    _runtimeAccessToken = stored;
    return stored;
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
    _runtimeAccessToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
  }
}
