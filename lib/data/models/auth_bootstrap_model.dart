import 'package:today/domain/entities/auth_bootstrap_entity.dart';

class AuthBootstrapModel extends AuthBootstrapEntity {
  const AuthBootstrapModel({
    required super.userId,
    required super.displayName,
    super.email,
  });

  factory AuthBootstrapModel.fromJson(Map<String, dynamic> json) {
    return AuthBootstrapModel(
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String,
      email: json['email'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'user_id': userId,
    'display_name': displayName,
    if (email != null) 'email': email,
  };

  factory AuthBootstrapModel.fromStorage(Map<String, dynamic> json) {
    return AuthBootstrapModel(
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String,
      email: json['email'] as String?,
    );
  }
}
