import 'package:firebase_auth/firebase_auth.dart';

/// Supplies fresh Firebase ID tokens for TodAI API Bearer auth.
class FirebaseTokenProvider {
  FirebaseTokenProvider({FirebaseAuth? firebaseAuth})
    : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Future<String?> getBearerToken({bool forceRefresh = false}) async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return user.getIdToken(forceRefresh);
  }
}
