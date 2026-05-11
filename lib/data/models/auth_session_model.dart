import 'package:today/domain/entities/auth_session_entity.dart';

class AuthSessionModel extends AuthSessionEntity {
  const AuthSessionModel({required super.accessToken});

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(accessToken: json['access_token'] as String);
  }
}
