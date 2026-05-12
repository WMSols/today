import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:today/presentation/controllers/feedback/haptics_controller.dart';
import 'package:today/core/network/api_exceptions.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';
import 'package:today/domain/usecases/login_usecase.dart';
import 'package:today/domain/usecases/signup_usecase.dart';
import 'package:today/presentation/routes/app_routes.dart';

class AuthController extends GetxController {
  AuthController(this._loginUseCase, this._signupUseCase);

  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;

  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();
  final loginUsernameController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final signupUsernameController = TextEditingController();
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

  Future<void> submit() async {
    final activeFormKey = isLoginMode.value ? loginFormKey : signupFormKey;
    final valid = activeFormKey.currentState?.validate() ?? false;
    if (!valid || isLoading.value) return;

    isLoading.value = true;
    try {
      if (isLoginMode.value) {
        await _loginUseCase(
          username: loginUsernameController.text.trim(),
          password: loginPasswordController.text,
          rememberMe: rememberMe.value,
        );
        AppToast.showSuccess('Login successful');
        if (Get.isRegistered<HapticsController>()) {
          Get.find<HapticsController>().impact();
        }
        Get.offAllNamed(AppRoutes.mainApp);
      } else {
        await _signupUseCase(
          username: signupUsernameController.text.trim(),
          password: signupPasswordController.text,
          timezone: DateTime.now().timeZoneName,
          autoLogin: false,
        );
        AppToast.showSuccess('Account created successfully');
        if (Get.isRegistered<HapticsController>()) {
          Get.find<HapticsController>().impact();
        }
        loginUsernameController.text = signupUsernameController.text.trim();
        loginPasswordController.clear();
        switchMode(true);
      }
    } catch (e) {
      if (Get.isRegistered<HapticsController>()) {
        Get.find<HapticsController>().impact();
      }
      final resolved = _resolveAuthError(e, isLogin: isLoginMode.value);
      AppToast.showError(resolved.$1, resolved.$2);
    } finally {
      isLoading.value = false;
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

      if (normalized.contains('username') &&
          (normalized.contains('exists') ||
              normalized.contains('taken') ||
              normalized.contains('already'))) {
        return ('Username already exists', 'Choose a different username.');
      }

      if (normalized.contains('invalid credentials') ||
          (normalized.contains('invalid') && normalized.contains('password')) ||
          normalized.contains('wrong password') ||
          normalized.contains('incorrect password')) {
        return ('Invalid credentials', 'Check username and password.');
      }

      if (statusCode == 401) {
        return ('Unauthorized', 'Invalid username or password.');
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

  String? validateUsername(String? value) {
    final username = value?.trim() ?? '';
    if (username.isEmpty) {
      return 'Username is required';
    }
    if (username.length < 3 || username.length > 24) {
      return 'Username must be 3-24 characters';
    }
    final usernamePattern = RegExp(r'^[a-zA-Z0-9._]+$');
    if (!usernamePattern.hasMatch(username)) {
      return 'Use only letters, numbers, dot or underscore';
    }
    if (username.startsWith('.') ||
        username.endsWith('.') ||
        username.contains('..')) {
      return 'Username format is invalid';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (value.contains(' ')) {
      return 'Password must not contain spaces';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Include at least 1 uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Include at least 1 lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Include at least 1 number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\\[\]~`]').hasMatch(value)) {
      return 'Include at least 1 special character';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    final passwordError = validatePassword(value);
    if (passwordError != null) {
      return passwordError;
    }
    if ((value ?? '') != signupPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  void onClose() {
    loginUsernameController.dispose();
    loginPasswordController.dispose();
    signupUsernameController.dispose();
    signupPasswordController.dispose();
    signupConfirmPasswordController.dispose();
    super.onClose();
  }
}
