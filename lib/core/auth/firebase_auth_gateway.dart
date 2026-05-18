import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:today/firebase_options.dart';

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
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (!_shouldAttemptOAuthEmailLink(e.code)) rethrow;
      return _signInWithOAuthProviderAndLinkEmail(
        email: email,
        password: password,
      );
    }
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code != 'email-already-in-use') rethrow;
      return _signInWithOAuthProviderAndLinkEmail(
        email: email,
        password: password,
      );
    }
  }

  /// Links email/password to the signed-in user when missing (e.g. after Google/Apple).
  Future<void> linkEmailPasswordIfAbsent({
    required String email,
    required String password,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final normalizedEmail = email.trim().toLowerCase();
    final accountEmail = user.email?.trim().toLowerCase();
    if (accountEmail == null || accountEmail != normalizedEmail) return;

    if (_hasPasswordProvider(user)) return;

    try {
      await user.linkWithCredential(
        EmailAuthProvider.credential(email: email.trim(), password: password),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked' ||
          e.code == 'credential-already-in-use') {
        return;
      }
      rethrow;
    }
  }

  Future<void> _ensureGoogleSignInReady() async {
    if (_googleInitialized) return;
    if (!_isGooglePlatformSupported) {
      throw FirebaseAuthException(
        code: 'google-sign-in-unavailable',
        message: 'Google sign-in is only supported on Android, iOS, and macOS.',
      );
    }
    final iosClientId = defaultTargetPlatform == TargetPlatform.iOS
        ? DefaultFirebaseOptions.ios.iosClientId
        : null;
    await GoogleSignIn.instance.initialize(
      clientId: iosClientId,
      serverClientId: DefaultFirebaseOptions.googleWebClientId,
    );
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

  bool _shouldAttemptOAuthEmailLink(String code) {
    return code == 'invalid-credential' ||
        code == 'wrong-password' ||
        code == 'invalid-login-credentials';
  }

  bool _hasPasswordProvider(User user) {
    return user.providerData.any((info) => info.providerId == 'password');
  }

  bool _emailMatchesAccount(String email, User? user) {
    final accountEmail = user?.email?.trim().toLowerCase();
    if (accountEmail == null || accountEmail.isEmpty) return false;
    return accountEmail == email.trim().toLowerCase();
  }

  /// Signs in with Google or Apple for [email], links password, then completes email sign-in.
  Future<UserCredential> _signInWithOAuthProviderAndLinkEmail({
    required String email,
    required String password,
  }) async {
    FirebaseAuthException? lastError;

    if (_isGooglePlatformSupported) {
      try {
        final googleCred = await signInWithGoogle();
        if (_emailMatchesAccount(email, googleCred.user)) {
          return _finishOAuthEmailLink(
            email: email,
            password: password,
            oauthCred: googleCred,
          );
        }
        await _auth.signOut();
      } on FirebaseAuthException catch (e) {
        lastError = e;
      } catch (_) {
        // Google sign-in canceled or failed — try Apple below.
      }
    }

    if (_isApplePlatformSupported) {
      try {
        final appleCred = await signInWithApple();
        if (_emailMatchesAccount(email, appleCred.user)) {
          return _finishOAuthEmailLink(
            email: email,
            password: password,
            oauthCred: appleCred,
          );
        }
        await _auth.signOut();
      } on FirebaseAuthException catch (e) {
        lastError = e;
      }
    }

    throw lastError ??
        FirebaseAuthException(
          code: 'invalid-credential',
          message:
              'No matching Google or Apple account found for this email. '
              'Sign in with the same provider you used originally.',
        );
  }

  Future<UserCredential> _finishOAuthEmailLink({
    required String email,
    required String password,
    required UserCredential oauthCred,
  }) async {
    await linkEmailPasswordIfAbsent(email: email, password: password);

    final user = _auth.currentUser;
    if (user != null && _hasPasswordProvider(user)) {
      await _auth.signOut();
      return _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    }

    return oauthCred;
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
          await GoogleSignIn.instance.initialize(
            clientId: defaultTargetPlatform == TargetPlatform.iOS
                ? DefaultFirebaseOptions.ios.iosClientId
                : null,
            serverClientId: DefaultFirebaseOptions.googleWebClientId,
          );
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
