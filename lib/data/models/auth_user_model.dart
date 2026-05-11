import 'package:today/domain/entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  const AuthUserModel({required super.id, required super.username});

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: json['id'] as String,
      username: json['username'] as String,
    );
  }
}
