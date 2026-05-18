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
import 'package:today/presentation/controllers/animation/app_animation_controller.dart';
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

  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
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
      AppToast.showError(
        AppTexts.googleSignInFailedTitle,
        e.description ?? e.toString(),
      );
    } on FirebaseAuthException catch (e) {
      AppToast.showError(
        AppTexts.googleSignInFailedTitle,
        AuthErrorMessages.firebase(e),
      );
    } catch (e) {
      if (e is DioException) {
        final r = AuthErrorMessages.resolveDio(e, isLogin: true);
        AppToast.showError(r.$1, r.$2);
      } else {
        AppToast.showError(
          AppTexts.googleSignInFailedTitle,
          AppTexts.pleaseTryAgainShort,
        );
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
        AppTexts.appleSignInInfoTitle,
        AppTexts.appleSignInInfoBody,
      );
      return;
    }
    isLoading.value = true;
    try {
      final cred = await _firebaseAuth.signInWithApple();
      await _linkEmailPasswordFromActiveForm(cred.user);
      await _persistApiSessionAfterFirebase(cred);
      await _completeAuthAndGoHome(AppTexts.signedInWithApple);
    } on FirebaseAuthException catch (e) {
      AppToast.showError(
        AppTexts.appleSignInFailedTitle,
        AuthErrorMessages.firebase(e),
      );
    } catch (e) {
      if (e is DioException) {
        final r = AuthErrorMessages.resolveDio(e, isLogin: true);
        AppToast.showError(r.$1, r.$2);
      } else {
        AppToast.showError(
          AppTexts.appleSignInFailedTitle,
          AppTexts.pleaseTryAgainShort,
        );
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
      AppToast.showError(
        isLoginMode.value
            ? AppTexts.loginFailedTitle
            : AppTexts.signUpFailedTitle,
        AuthErrorMessages.firebase(e),
      );
    } catch (e) {
      if (Get.isRegistered<HapticsController>()) {
        Get.find<HapticsController>().impact();
      }
      if (e is DioException) {
        final resolved = AuthErrorMessages.resolveDio(
          e,
          isLogin: isLoginMode.value,
        );
        AppToast.showError(resolved.$1, resolved.$2);
      } else {
        AppToast.showError(
          isLoginMode.value
              ? AppTexts.loginFailedTitle
              : AppTexts.signUpFailedTitle,
          AppTexts.pleaseTryAgainShort,
        );
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
    if (Get.isRegistered<AppAnimationController>()) {
      await Get.find<AppAnimationController>().offAllToMainApp<void>();
    } else {
      await Get.offAllNamed<void>(AppRoutes.mainApp);
    }
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
