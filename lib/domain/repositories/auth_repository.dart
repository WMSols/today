import 'package:today/domain/entities/auth_bootstrap_entity.dart';
import 'package:today/domain/entities/auth_config_entity.dart';
import 'package:today/domain/entities/health_status_entity.dart';

abstract class AuthRepository {
  Future<HealthStatusEntity> checkHealth();

  Future<AuthConfigEntity> getAuthConfig();

  /// Creates or verifies the TodAI user profile (`POST /api/auth/bootstrap`).
  Future<AuthBootstrapEntity> bootstrapUser({bool rememberMe = true});

  Future<AuthBootstrapEntity?> getCachedBootstrapUser();

  Future<bool> getRememberMePreference({bool defaultValue = true});

  Future<void> saveRememberMePreference(bool value);

  Future<void> saveLoginCredentials({
    required String email,
    required String password,
  });

  Future<({String? email, String? password})> getLoginCredentials();

  Future<void> clearLoginCredentials();

  Future<void> clearSession();
}
