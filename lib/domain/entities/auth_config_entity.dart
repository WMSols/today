class AuthConfigEntity {
  const AuthConfigEntity({
    required this.authRequired,
    required this.firebaseEnabled,
    required this.firebaseProjectId,
  });

  final bool authRequired;
  final bool firebaseEnabled;
  final String firebaseProjectId;
}
