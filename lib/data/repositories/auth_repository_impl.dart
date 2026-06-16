import 'package:today/core/storage/session_storage.dart';
import 'package:today/data/datasources/remote/auth_remote_data_source.dart';
import 'package:today/data/models/auth_bootstrap_model.dart';
import 'package:today/data/models/auth_config_model.dart';
import 'package:today/data/models/health_status_model.dart';
import 'package:today/domain/entities/auth_bootstrap_entity.dart';
import 'package:today/domain/entities/auth_config_entity.dart';
import 'package:today/domain/entities/health_status_entity.dart';
import 'package:today/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remoteDataSource, this._sessionStorage);

  final AuthRemoteDataSource _remoteDataSource;
  final SessionStorage _sessionStorage;

  @override
  Future<HealthStatusEntity> checkHealth() async {
    final raw = await _remoteDataSource.checkHealth();
    return HealthStatusModel.fromJson(raw);
  }

  @override
  Future<AuthConfigEntity> getAuthConfig() async {
    final raw = await _remoteDataSource.getAuthConfig();
    return AuthConfigModel.fromJson(raw);
  }

  @override
  Future<AuthBootstrapEntity> bootstrapUser({bool rememberMe = true}) async {
    final raw = await _remoteDataSource.bootstrapUser();
    final user = AuthBootstrapModel.fromJson(raw);
    await _sessionStorage.saveRememberMePreference(rememberMe);
    await _sessionStorage.saveBootstrapUser(user);
    return user;
  }

  @override
  Future<AuthBootstrapEntity?> getCachedBootstrapUser() async {
    final raw = await _sessionStorage.getBootstrapUser();
    if (raw == null) return null;
    return AuthBootstrapModel.fromStorage(raw);
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
  Future<void> clearSession() {
    return _sessionStorage.clearSession();
  }
}
