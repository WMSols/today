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
    await _sessionStorage.saveAccessToken(
      session.accessToken,
      persist: rememberMe,
    );
    return AuthResultEntity(user: user, session: session);
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
