import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:today/core/auth/firebase_auth_gateway.dart';
import 'package:today/presentation/controllers/feedback/haptics_controller.dart';
import 'package:today/core/network/api_exceptions.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';
import 'package:today/domain/repositories/auth_repository.dart';
import 'package:today/presentation/routes/app_routes.dart';

class AuthController extends GetxController {
  AuthController(this._authRepository, this._firebaseAuth);

  final AuthRepository _authRepository;
  final FirebaseAuthGateway _firebaseAuth;

  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupConfirmPasswordController = TextEditingController();

  final isLoginMode = true.obs;
  final isLoading = false.obs;
  final rememberMe = true.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isSignupPasswordVisible = false.obs;
  final isSignupConfirmPasswordVisible = false.obs;

  void switchMode(bool loginMode) {
    isLoginMode.value = loginMode;
    isPasswordVisible.value = false;
    isConfirmPasswordVisible.value = false;
    isSignupPasswordVisible.value = false;
    isSignupConfirmPasswordVisible.value = false;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void toggleSignupPasswordVisibility() {
    isSignupPasswordVisible.value = !isSignupPasswordVisible.value;
  }

  void toggleSignupConfirmPasswordVisibility() {
    isSignupConfirmPasswordVisible.value =
        !isSignupConfirmPasswordVisible.value;
  }

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  Future<void> signInWithGoogle() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final cred = await _firebaseAuth.signInWithGoogle();
      await _persistApiSessionAfterFirebase(cred);
      _toastSuccessAndGoHome('Signed in with Google');
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted ||
          e.code == GoogleSignInExceptionCode.uiUnavailable) {
        return;
      }
      AppToast.showError(
        'Google sign-in failed',
        e.description ?? e.toString(),
      );
    } on FirebaseAuthException catch (e) {
      AppToast.showError('Google sign-in failed', _messageForFirebaseAuth(e));
    } catch (e) {
      if (e is DioException) {
        final r = _resolveAuthError(e, isLogin: true);
        AppToast.showError(r.$1, r.$2);
      } else {
        AppToast.showError('Google sign-in failed', 'Please try again.');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithApple() async {
    if (isLoading.value) return;
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.iOS &&
            defaultTargetPlatform != TargetPlatform.macOS)) {
      AppToast.showInformation(
        'Apple sign-in',
        'Apple sign-in will be enabled on iOS when you are ready. Use email or Google here.',
      );
      return;
    }
    isLoading.value = true;
    try {
      final cred = await _firebaseAuth.signInWithApple();
      await _persistApiSessionAfterFirebase(cred);
      _toastSuccessAndGoHome('Signed in with Apple');
    } on FirebaseAuthException catch (e) {
      AppToast.showError('Apple sign-in failed', _messageForFirebaseAuth(e));
    } catch (e) {
      if (e is DioException) {
        final r = _resolveAuthError(e, isLogin: true);
        AppToast.showError(r.$1, r.$2);
      } else {
        AppToast.showError('Apple sign-in failed', 'Please try again.');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submit() async {
    final activeFormKey = isLoginMode.value ? loginFormKey : signupFormKey;
    final valid = activeFormKey.currentState?.validate() ?? false;
    if (!valid || isLoading.value) return;

    isLoading.value = true;
    try {
      if (isLoginMode.value) {
        final cred = await _firebaseAuth.signInWithEmailAndPassword(
          email: loginEmailController.text.trim(),
          password: loginPasswordController.text,
        );
        await _persistApiSessionAfterFirebase(cred);
        _toastSuccessAndGoHome('Login successful');
      } else {
        final cred = await _firebaseAuth.createUserWithEmailAndPassword(
          email: signupEmailController.text.trim(),
          password: signupPasswordController.text,
        );
        await _persistApiSessionAfterFirebase(
          cred,
          timezone: DateTime.now().timeZoneName,
        );
        _toastSuccessAndGoHome('Account created successfully');
      }
    } on FirebaseAuthException catch (e) {
      if (Get.isRegistered<HapticsController>()) {
        Get.find<HapticsController>().impact();
      }
      AppToast.showError(
        isLoginMode.value ? 'Login failed' : 'Sign up failed',
        _messageForFirebaseAuth(e),
      );
    } catch (e) {
      if (Get.isRegistered<HapticsController>()) {
        Get.find<HapticsController>().impact();
      }
      if (e is DioException) {
        final resolved = _resolveAuthError(e, isLogin: isLoginMode.value);
        AppToast.showError(resolved.$1, resolved.$2);
      } else {
        AppToast.showError(
          isLoginMode.value ? 'Login failed' : 'Sign up failed',
          'Please try again.',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _persistApiSessionAfterFirebase(
    UserCredential cred, {
    String? timezone,
  }) async {
    final user = cred.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'missing-user',
        message: 'No Firebase user returned.',
      );
    }
    final idToken = await user.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-id-token',
        message: 'Could not read Firebase ID token.',
      );
    }
    await _authRepository.exchangeFirebaseSession(
      idToken: idToken,
      rememberMe: rememberMe.value,
      timezone: timezone,
    );
  }

  void _toastSuccessAndGoHome(String title) {
    AppToast.showSuccess(title);
    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
    Get.offAllNamed(AppRoutes.mainApp);
  }

  String _messageForFirebaseAuth(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Password is too weak. Use a stronger password.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      case 'apple-sign-in-unavailable':
      case 'google-sign-in-unavailable':
        return e.message ?? e.code;
      default:
        return e.message?.trim().isNotEmpty == true
            ? e.message!.trim()
            : 'Authentication error (${e.code}).';
    }
  }

  (String, String) _resolveAuthError(Object error, {required bool isLogin}) {
    if (error is DioException) {
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
        return ('Email already in use', 'Sign in or use a different email.');
      }

      if (normalized.contains('invalid credentials') ||
          (normalized.contains('invalid') && normalized.contains('password')) ||
          normalized.contains('wrong password') ||
          normalized.contains('incorrect password')) {
        return ('Invalid credentials', 'Check email and password.');
      }

      if (statusCode == 401) {
        return ('Unauthorized', 'Invalid email or session.');
      }

      if (statusCode == 404) {
        return (
          'Server not configured',
          'Add POST /auth/firebase on your API to exchange Firebase ID tokens.',
        );
      }

      if (backendMessage.isNotEmpty) {
        return ('Authentication failed', backendMessage);
      }

      return (
        'Authentication failed',
        ApiExceptions.messageFromStatus(statusCode),
      );
    }

    return (isLogin ? 'Login failed' : 'Signup failed', 'Please try again.');
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    signupConfirmPasswordController.dispose();
    super.onClose();
  }
}
