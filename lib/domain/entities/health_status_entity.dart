class HealthStatusEntity {
  const HealthStatusEntity({
    required this.ok,
    required this.firebaseConfigured,
    required this.authRequired,
  });

  final bool ok;
  final bool firebaseConfigured;
  final bool authRequired;
}
