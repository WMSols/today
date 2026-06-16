class AuthBootstrapEntity {
  const AuthBootstrapEntity({
    required this.userId,
    required this.displayName,
    this.email,
  });

  final String userId;
  final String displayName;
  final String? email;
}
