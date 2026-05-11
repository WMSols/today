import 'package:today/domain/entities/auth_session_entity.dart';
import 'package:today/domain/entities/auth_user_entity.dart';
import 'package:today/domain/entities/me_entity.dart';

class AuthResultEntity {
  const AuthResultEntity({required this.user, required this.session});

  final AuthUserEntity user;
  final AuthSessionEntity session;
}

abstract class AuthRepository {
  Future<AuthResultEntity> signup({
    required String username,
    required String password,
    String? timezone,
    bool autoLogin = false,
  });

  Future<AuthResultEntity> login({
    required String username,
    required String password,
    bool rememberMe = true,
  });

  Future<MeEntity> getMe();
  Future<String?> getAccessToken();
  Future<void> clearSession();
}
