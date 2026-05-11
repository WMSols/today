import 'package:shared_preferences/shared_preferences.dart';

class SessionStorage {
  static const String _accessTokenKey = 'access_token';
  String? _runtimeAccessToken;

  Future<void> saveAccessToken(
    String token, {
    bool persist = true,
  }) async {
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

  Future<void> clearSession() async {
    _runtimeAccessToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
  }
}

