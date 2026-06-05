import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:today/core/constants/api_constants.dart';
import 'package:today/core/auth/firebase_auth_gateway.dart';
import 'package:today/presentation/controllers/settings/haptics_controller.dart';
import 'package:today/core/auth/auth_error_messages.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';
import 'package:today/domain/repositories/auth_repository.dart';
import 'package:today/domain/usecases/get_me_usecase.dart';
import 'package:today/core/navigation/post_auth_navigation.dart';
import 'package:today/presentation/routes/route_arguments.dart';

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
  final isSignupPasswordVisible = false.obs;
  final isSignupConfirmPasswordVisible = false.obs;

  void switchMode(bool loginMode) {
    isLoginMode.value = loginMode;
    isPasswordVisible.value = false;
    isSignupPasswordVisible.value = false;
    isSignupConfirmPasswordVisible.value = false;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleSignupPasswordVisibility() {
    isSignupPasswordVisible.value = !isSignupPasswordVisible.value;
  }

  void toggleSignupConfirmPasswordVisibility() {
    isSignupConfirmPasswordVisible.value =
        !isSignupConfirmPasswordVisible.value;
  }

  Future<void> toggleRememberMe(bool? value) async {
    final enabled = value ?? false;
    rememberMe.value = enabled;
    await _authRepository.saveRememberMePreference(enabled);
    if (!enabled) {
      await _authRepository.clearLoginCredentials();
      loginEmailController.clear();
      loginPasswordController.clear();
    }
  }

  AppButtonColors authTabColors(bool isDark) {
    return AppButtonColors(
      filledBackground: isDark ? AppColors.secondary : AppColors.primary,
      filledForeground: isDark ? AppColors.primary : AppColors.secondary,
      outlinedBackground: Colors.transparent,
      outlinedForeground: isDark ? AppColors.secondary : AppColors.primary,
      outlinedBorder: isDark ? AppColors.secondary : AppColors.primary,
    );
  }

  Future<void> signInWithGoogle() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final cred = await _firebaseAuth.signInWithGoogle();
      await _linkEmailPasswordFromActiveForm(cred.user);
      await _persistApiSessionAfterFirebase(
        cred,
        timezone: DateTime.now().timeZoneName,
      );
      await _completeAuthAndGoHome(AppTexts.signedInWithGoogle);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled ||
          e.code == GoogleSignInExceptionCode.interrupted ||
          e.code == GoogleSignInExceptionCode.uiUnavailable) {
        return;
      }
      AppToast.showError(e.description ?? e.toString());
    } on FirebaseAuthException catch (e) {
      AppToast.showError(AuthErrorMessages.firebase(e));
    } catch (e) {
      if (e is DioException) {
        final r = AuthErrorMessages.resolveDio(e, isLogin: true);
        AppToast.showError(r.$2.isNotEmpty ? r.$2 : r.$1);
      } else {
        AppToast.showError(AppTexts.pleaseTryAgainShort);
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
      AppToast.showInformation(AppTexts.appleSignInInfoBody);
      return;
    }
    isLoading.value = true;
    try {
      final cred = await _firebaseAuth.signInWithApple();
      await _linkEmailPasswordFromActiveForm(cred.user);
      await _persistApiSessionAfterFirebase(cred);
      await _completeAuthAndGoHome(AppTexts.signedInWithApple);
    } on FirebaseAuthException catch (e) {
      AppToast.showError(AuthErrorMessages.firebase(e));
    } catch (e) {
      if (e is DioException) {
        final r = AuthErrorMessages.resolveDio(e, isLogin: true);
        AppToast.showError(r.$2.isNotEmpty ? r.$2 : r.$1);
      } else {
        AppToast.showError(AppTexts.pleaseTryAgainShort);
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
        await _persistLoginCredentialsIfNeeded();
        await _completeAuthAndGoHome(AppTexts.loginSuccessful);
      } else {
        final cred = await _firebaseAuth.createUserWithEmailAndPassword(
          email: signupEmailController.text.trim(),
          password: signupPasswordController.text,
        );
        await _persistApiSessionAfterFirebase(
          cred,
          timezone: DateTime.now().timeZoneName,
        );
        await _completeAuthAndGoHome(AppTexts.accountCreatedSuccess);
      }
    } on FirebaseAuthException catch (e) {
      if (Get.isRegistered<HapticsController>()) {
        Get.find<HapticsController>().impact();
      }
      AppToast.showError(AuthErrorMessages.firebase(e));
    } catch (e) {
      if (Get.isRegistered<HapticsController>()) {
        Get.find<HapticsController>().impact();
      }
      if (e is DioException) {
        final resolved = AuthErrorMessages.resolveDio(
          e,
          isLogin: isLoginMode.value,
        );
        AppToast.showError(resolved.$2.isNotEmpty ? resolved.$2 : resolved.$1);
      } else {
        AppToast.showError(AppTexts.pleaseTryAgainShort);
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _linkEmailPasswordFromActiveForm(User? user) async {
    final accountEmail = user?.email?.trim();
    if (accountEmail == null || accountEmail.isEmpty) return;

    final String password;
    if (isLoginMode.value) {
      final formEmail = loginEmailController.text.trim();
      if (formEmail.isEmpty ||
          formEmail.toLowerCase() != accountEmail.toLowerCase()) {
        return;
      }
      password = loginPasswordController.text;
    } else {
      final formEmail = signupEmailController.text.trim();
      if (formEmail.isEmpty ||
          formEmail.toLowerCase() != accountEmail.toLowerCase()) {
        return;
      }
      password = signupPasswordController.text;
      if (password != signupConfirmPasswordController.text) return;
    }

    if (password.isEmpty) return;

    await _firebaseAuth.linkEmailPasswordIfAbsent(
      email: accountEmail,
      password: password,
    );
  }

  Future<void> _persistApiSessionAfterFirebase(
    UserCredential cred, {
    String? timezone,
  }) async {
    final user = cred.user;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'missing-user',
        message: AppTexts.firebaseMissingUserMessage,
      );
    }
    final idToken = await user.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      throw FirebaseAuthException(
        code: 'missing-id-token',
        message: AppTexts.firebaseMissingIdTokenMessage,
      );
    }
    if (!ApiConstants.backendApiEnabled) {
      await _authRepository.saveFirebaseIdTokenSession(
        idToken: idToken,
        rememberMe: rememberMe.value,
      );
      return;
    }

    await _authRepository.exchangeFirebaseSession(
      idToken: idToken,
      rememberMe: rememberMe.value,
      timezone: timezone,
    );
    if (Get.isRegistered<GetMeUseCase>()) {
      await Get.find<GetMeUseCase>()();
    }
  }

  Future<void> _completeAuthAndGoHome(String title) async {
    AppToast.showSuccess(title);
    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
    await Future<void>.delayed(const Duration(milliseconds: 300));
    await PostAuthNavigation.goAfterAuth();
  }

  void _applyRouteArguments() {
    final args = Get.arguments;
    if (args is! Map) return;
    if (args[AuthRouteArgs.openSignup] == true) {
      switchMode(false);
    } else if (args[AuthRouteArgs.openLogin] == true) {
      switchMode(true);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _applyRouteArguments();
    _loadRememberMePreference();
  }

  Future<void> _loadRememberMePreference() async {
    rememberMe.value = await _authRepository.getRememberMePreference();
    if (!rememberMe.value) return;

    final saved = await _authRepository.getLoginCredentials();
    final email = saved.email?.trim();
    if (email != null && email.isNotEmpty) {
      loginEmailController.text = email;
    }
    final password = saved.password;
    if (password != null && password.isNotEmpty) {
      loginPasswordController.text = password;
    }
  }

  Future<void> _persistLoginCredentialsIfNeeded() async {
    if (!isLoginMode.value) return;

    if (rememberMe.value) {
      await _authRepository.saveLoginCredentials(
        email: loginEmailController.text.trim(),
        password: loginPasswordController.text,
      );
      return;
    }

    await _authRepository.clearLoginCredentials();
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
