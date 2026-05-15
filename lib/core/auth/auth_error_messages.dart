import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:today/core/network/api_exceptions.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

/// User-facing auth error copy shared by [AuthController].
class AuthErrorMessages {
  AuthErrorMessages._();

  static String firebase(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return AppTexts.firebaseInvalidEmail;
      case 'user-disabled':
        return AppTexts.firebaseUserDisabled;
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return AppTexts.firebaseIncorrectEmailOrPassword;
      case 'email-already-in-use':
        return AppTexts.firebaseEmailAlreadyInUse;
      case 'weak-password':
        return AppTexts.firebaseWeakPassword;
      case 'network-request-failed':
        return AppTexts.firebaseNetworkError;
      case 'too-many-requests':
        return AppTexts.firebaseTooManyRequests;
      case 'apple-sign-in-unavailable':
      case 'google-sign-in-unavailable':
        return e.message ?? e.code;
      default:
        return e.message?.trim().isNotEmpty == true
            ? e.message!.trim()
            : AppTexts.firebaseAuthErrorWithCode(e.code);
    }
  }

  static (String, String) resolveDio(
    DioException error, {
    required bool isLogin,
  }) {
    final statusCode = error.response?.statusCode;
    final raw = error.response?.data;
    String backendMessage = '';

    if (raw is Map<String, dynamic>) {
      final candidates = [
        raw['message'],
        raw['detail'],
        raw['error'],
        raw['reason'],
      ];
      for (final c in candidates) {
        if (c is String && c.trim().isNotEmpty) {
          backendMessage = c.trim();
          break;
        }
      }
    } else if (raw is String && raw.trim().isNotEmpty) {
      backendMessage = raw.trim();
    }

    final normalized = backendMessage.toLowerCase();

    if (normalized.contains('email') &&
        (normalized.contains('exists') ||
            normalized.contains('taken') ||
            normalized.contains('already'))) {
      return (AppTexts.emailAlreadyInUseTitle, AppTexts.emailAlreadyInUseBody);
    }

    if (normalized.contains('invalid credentials') ||
        (normalized.contains('invalid') && normalized.contains('password')) ||
        normalized.contains('wrong password') ||
        normalized.contains('incorrect password')) {
      return (
        AppTexts.invalidCredentialsTitle,
        AppTexts.invalidCredentialsBody,
      );
    }

    if (statusCode == 401) {
      return (AppTexts.unauthorizedTitle, AppTexts.unauthorizedBody);
    }

    if (statusCode == 404) {
      return (
        AppTexts.serverNotConfiguredTitle,
        AppTexts.serverNotConfiguredBody,
      );
    }

    if (backendMessage.isNotEmpty) {
      return (AppTexts.authenticationFailedTitle, backendMessage);
    }

    return (
      AppTexts.authenticationFailedTitle,
      ApiExceptions.messageFromStatus(statusCode),
    );
  }

  static (String, String) genericFailure({required bool isLogin}) {
    return (
      isLogin ? AppTexts.loginFailedTitle : AppTexts.signUpFailedTitle,
      AppTexts.pleaseTryAgainShort,
    );
  }
}
