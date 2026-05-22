import 'package:today/core/storage/session_storage.dart';
import 'package:today/data/datasources/remote/auth_remote_data_source.dart';
import 'package:today/data/models/auth_session_model.dart';
import 'package:today/data/models/auth_user_model.dart';
import 'package:today/data/models/me_model.dart';
import 'package:today/domain/entities/me_entity.dart';
import 'package:today/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource, this._sessionStorage);

  final AuthRemoteDataSource _remoteDataSource;
  final SessionStorage _sessionStorage;

  @override
  Future<AuthResultEntity> signup({
    required String username,
    required String password,
    String? timezone,
    bool autoLogin = false,
  }) async {
    final raw = await _remoteDataSource.signup(
      username: username,
      password: password,
      timezone: timezone,
    );
    final user = AuthUserModel.fromJson(raw['user'] as Map<String, dynamic>);
    final session = AuthSessionModel.fromJson(
      raw['session'] as Map<String, dynamic>,
    );
    if (autoLogin) {
      await _sessionStorage.saveAccessToken(session.accessToken, persist: true);
    }
    return AuthResultEntity(user: user, session: session);
  }

  @override
  Future<AuthResultEntity> login({
    required String username,
    required String password,
    bool rememberMe = true,
  }) async {
    final raw = await _remoteDataSource.login(
      username: username,
      password: password,
    );
    final user = AuthUserModel.fromJson(raw['user'] as Map<String, dynamic>);
    final session = AuthSessionModel.fromJson(
      raw['session'] as Map<String, dynamic>,
    );
    await _persistSession(session.accessToken, rememberMe: rememberMe);
    return AuthResultEntity(user: user, session: session);
  }

  @override
  Future<AuthResultEntity> exchangeFirebaseSession({
    required String idToken,
    bool rememberMe = true,
    String? timezone,
  }) async {
    final raw = await _remoteDataSource.exchangeFirebaseSession(
      idToken: idToken,
      timezone: timezone,
    );
    final user = AuthUserModel.fromJson(raw['user'] as Map<String, dynamic>);
    final session = AuthSessionModel.fromJson(
      raw['session'] as Map<String, dynamic>,
    );
    await _persistSession(session.accessToken, rememberMe: rememberMe);
    return AuthResultEntity(user: user, session: session);
  }

  @override
  Future<void> saveFirebaseIdTokenSession({
    required String idToken,
    bool rememberMe = true,
  }) {
    return _persistSession(idToken, rememberMe: rememberMe);
  }

  Future<void> _persistSession(String token, {required bool rememberMe}) async {
    await _sessionStorage.saveRememberMePreference(rememberMe);
    await _sessionStorage.saveAccessToken(token, persist: rememberMe);
  }

  @override
  Future<bool> getRememberMePreference({bool defaultValue = true}) {
    return _sessionStorage.getRememberMePreference(defaultValue: defaultValue);
  }

  @override
  Future<void> saveRememberMePreference(bool value) {
    return _sessionStorage.saveRememberMePreference(value);
  }

  @override
  Future<void> saveLoginCredentials({
    required String email,
    required String password,
  }) {
    return _sessionStorage.saveLoginCredentials(
      email: email,
      password: password,
    );
  }

  @override
  Future<({String? email, String? password})> getLoginCredentials() {
    return _sessionStorage.getLoginCredentials();
  }

  @override
  Future<void> clearLoginCredentials() {
    return _sessionStorage.clearLoginCredentials();
  }

  @override
  Future<MeEntity> getMe() async {
    final raw = await _remoteDataSource.getMe();
    return MeModel.fromJson(raw);
  }

  @override
  Future<String?> getAccessToken() {
    return _sessionStorage.getAccessToken();
  }

  @override
  Future<void> clearSession() {
    return _sessionStorage.clearSession();
  }
}
