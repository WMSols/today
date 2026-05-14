import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Firebase Auth + Google / Apple identity flows used by [AuthController].
class FirebaseAuthGateway {
  FirebaseAuthGateway({FirebaseAuth? firebaseAuth})
    : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;
  bool _googleInitialized = false;

  FirebaseAuth get auth => _auth;

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> _ensureGoogleSignInReady() async {
    if (_googleInitialized) return;
    if (!_isGooglePlatformSupported) {
      throw FirebaseAuthException(
        code: 'google-sign-in-unavailable',
        message: 'Google sign-in is only supported on Android, iOS, and macOS.',
      );
    }
    await GoogleSignIn.instance.initialize();
    _googleInitialized = true;
  }

  bool get _isGooglePlatformSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  bool get _isApplePlatformSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  Future<UserCredential> signInWithGoogle() async {
    await _ensureGoogleSignInReady();
    final account = await GoogleSignIn.instance.authenticate();
    final googleAuth = account.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw FirebaseAuthException(
        code: 'google-missing-id-token',
        message: 'Google did not return an ID token. Check Firebase and SHA-1.',
      );
    }
    final credential = GoogleAuthProvider.credential(idToken: idToken);
    return _auth.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithApple() async {
    if (!_isApplePlatformSupported) {
      throw FirebaseAuthException(
        code: 'apple-sign-in-unavailable',
        message: 'Apple sign-in is only available on iOS and macOS.',
      );
    }
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: const [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );
    final idToken = appleCredential.identityToken;
    if (idToken == null || idToken.isEmpty) {
      throw FirebaseAuthException(
        code: 'apple-missing-id-token',
        message: 'Apple did not return an identity token.',
      );
    }
    final oauthCredential = OAuthProvider(
      'apple.com',
    ).credential(idToken: idToken, rawNonce: rawNonce);
    return _auth.signInWithCredential(oauthCredential);
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> signOut() async {
    if (_isGooglePlatformSupported) {
      try {
        if (!_googleInitialized) {
          await GoogleSignIn.instance.initialize();
          _googleInitialized = true;
        }
        await GoogleSignIn.instance.signOut();
      } catch (_) {
        // Ignore sign-out failures when Google was never configured.
      }
    }
    await _auth.signOut();
  }
}
