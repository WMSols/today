import 'package:today/domain/entities/health_status_entity.dart';

class HealthStatusModel extends HealthStatusEntity {
  const HealthStatusModel({
    required super.ok,
    required super.firebaseConfigured,
    required super.authRequired,
  });

  factory HealthStatusModel.fromJson(Map<String, dynamic> json) {
    return HealthStatusModel(
      ok: json['ok'] as bool? ?? false,
      firebaseConfigured: json['firebase_configured'] as bool? ?? false,
      authRequired: json['auth_required'] as bool? ?? true,
    );
  }
}
