import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:today/core/init/unauthenticated_route_resolver.dart';
import 'package:today/presentation/routes/app_routes.dart';
import 'package:today/core/auth/firebase_auth_gateway.dart';
import 'package:today/core/config/env_config.dart';
import 'package:today/core/constants/api_constants.dart';
import 'package:today/core/init/app_system_ui.dart';
import 'package:today/di/app_binding.dart';
import 'package:today/domain/usecases/bootstrap_user_usecase.dart';
import 'package:today/domain/usecases/check_health_usecase.dart';
import 'package:today/domain/usecases/get_auth_config_usecase.dart';
import 'package:today/domain/repositories/auth_repository.dart';
import 'package:today/presentation/controllers/settings/accent_color_controller.dart';
import 'package:today/presentation/controllers/settings/haptics_controller.dart';
import 'package:today/presentation/controllers/settings/theme_controller.dart';
import 'package:today/presentation/controllers/settings/vacation_mode_controller.dart';
import 'package:today/firebase_options.dart';

/// Handles async app bootstrap: env, DI, and initial route resolution.
abstract class AppInitializer {
  static String initialRoute = AppRoutes.onboarding;

  static Brightness overlayForStoredTheme() {
    final preference = Get.find<ThemeController>().preference;
    return switch (preference) {
      AppThemePreference.dark => Brightness.dark,
      AppThemePreference.light => Brightness.light,
      AppThemePreference.system =>
        WidgetsBinding.instance.platformDispatcher.platformBrightness,
    };
  }

  /// Full bootstrap while the splash screen is visible.
  static Future<void> init() async {
    await _ensureCoreServices();
    await EnvConfig.load();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppBinding().dependencies();
    Get.put<HapticsController>(HapticsController(), permanent: true);
    Get.put<VacationModeController>(VacationModeController(), permanent: true);
    await Get.find<HapticsController>().loadFromStorage();
    await Get.find<VacationModeController>().loadFromStorage();
    if (ApiConstants.backendApiEnabled) {
      await _runStartupApiChecks();
    }
    initialRoute = await _resolveInitialRoute();
  }

  static Future<void> _runStartupApiChecks() async {
    try {
      await Get.find<CheckHealthUseCase>()();
    } catch (e) {
      debugPrint('TodAI health check failed: $e');
    }

    try {
      final config = await Get.find<GetAuthConfigUseCase>()();
      final expectedProjectId =
          DefaultFirebaseOptions.currentPlatform.projectId;
      if (config.firebaseProjectId.isNotEmpty &&
          config.firebaseProjectId != expectedProjectId) {
        debugPrint(
          'TodAI firebase_project_id mismatch: '
          'expected $expectedProjectId, got ${config.firebaseProjectId}',
        );
      }
    } catch (e) {
      debugPrint('TodAI auth config check failed: $e');
    }
  }

  static Future<void> _ensureCoreServices() async {
    if (!Get.isRegistered<SharedPreferences>()) {
      await Get.putAsync<SharedPreferences>(
        SharedPreferences.getInstance,
        permanent: true,
      );
    }
    await Get.find<ThemeController>().loadFromStorage();
    await Get.find<AccentColorController>().loadFromStorage();
    SystemChrome.setSystemUIOverlayStyle(
      AppSystemUi.overlayFor(overlayForStoredTheme()),
    );
  }

  static Future<String> _resolveInitialRoute() async {
    final authRepository = Get.find<AuthRepository>();
    if (!await authRepository.getRememberMePreference()) {
      await _clearFirebaseSession(authRepository);
      return UnauthenticatedRouteResolver.resolve();
    }

    if (!ApiConstants.backendApiEnabled) {
      return _resolveInitialRouteOffline(authRepository);
    }

    return _resolveInitialRouteOnline(authRepository);
  }

  static Future<String> _resolveInitialRouteOnline(
    AuthRepository authRepository,
  ) async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        return UnauthenticatedRouteResolver.resolve();
      }
      await Get.find<BootstrapUserUseCase>()(rememberMe: true);
      return AppRoutes.mainApp;
    } catch (_) {
      await _clearFirebaseSession(authRepository);
      return UnauthenticatedRouteResolver.resolve();
    }
  }

  /// Firebase session only when the backend API is disabled.
  static Future<String> _resolveInitialRouteOffline(
    AuthRepository authRepository,
  ) async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        return UnauthenticatedRouteResolver.resolve();
      }
      await Get.find<BootstrapUserUseCase>()(rememberMe: true);
      return AppRoutes.mainApp;
    } catch (_) {
      await _clearFirebaseSession(authRepository);
      return UnauthenticatedRouteResolver.resolve();
    }
  }

  static Future<void> _clearFirebaseSession(
    AuthRepository authRepository,
  ) async {
    try {
      await Get.find<FirebaseAuthGateway>().signOut();
    } catch (_) {}
    try {
      await authRepository.clearSession();
    } catch (_) {}
  }
}
