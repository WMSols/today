/// Offline stub payloads used while [ApiConstants.backendApiEnabled] is false.
abstract class ApiStubs {
  ApiStubs._();

  static Map<String, dynamic> authSession({
    String accessToken = 'offline-session',
    String username = 'guest',
    String userId = 'local-user',
  }) =>
      <String, dynamic>{
        'user': <String, dynamic>{'id': userId, 'username': username},
        'session': <String, dynamic>{'access_token': accessToken},
      };

  static Map<String, dynamic> me({
    String username = 'guest',
    String userId = 'local-user',
  }) =>
      <String, dynamic>{
        'user': <String, dynamic>{'id': userId, 'username': username},
        'wallet': <String, dynamic>{
          'id': 'local-wallet',
          'user_id': userId,
          'balance': 0,
          'updated_at': DateTime.now().toUtc().toIso8601String(),
        },
      };

  static Map<String, dynamic> taskActionResult() => <String, dynamic>{
        'ok': true,
      };
}
