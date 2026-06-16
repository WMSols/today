import 'package:today/domain/entities/auth_config_entity.dart';

class AuthConfigModel extends AuthConfigEntity {
  const AuthConfigModel({
    required super.authRequired,
    required super.firebaseEnabled,
    required super.firebaseProjectId,
  });

  factory AuthConfigModel.fromJson(Map<String, dynamic> json) {
    final providers = json['providers'] as Map<String, dynamic>? ?? {};
    return AuthConfigModel(
      authRequired: json['auth_required'] as bool? ?? true,
      firebaseEnabled: providers['firebase'] as bool? ?? false,
      firebaseProjectId: json['firebase_project_id'] as String? ?? '',
    );
  }
}
