import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:today/presentation/routes/app_routes.dart';
import 'package:today/core/auth/firebase_auth_gateway.dart';
import 'package:today/core/config/env_config.dart';
import 'package:today/core/init/app_system_ui.dart';
import 'package:today/di/app_binding.dart';
import 'package:today/domain/usecases/get_me_usecase.dart';
import 'package:today/domain/repositories/auth_repository.dart';
import 'package:today/presentation/controllers/feedback/haptics_controller.dart';
import 'package:today/presentation/controllers/theme/theme_controller.dart';
import 'package:today/firebase_options.dart';

/// Handles async app bootstrap: env, DI, and initial route resolution.
abstract class AppInitializer {
  static String initialRoute = AppRoutes.onboarding;

  static Future<void> init() async {
    await EnvConfig.load();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AppSystemUi.setOverlayForPlatformBrightness();
    AppBinding().dependencies();
    await Get.putAsync<SharedPreferences>(
      SharedPreferences.getInstance,
      permanent: true,
    );
    Get.put<ThemeController>(ThemeController(), permanent: true);
    await Get.find<ThemeController>().loadFromStorage();
    Get.put<HapticsController>(HapticsController(), permanent: true);
    await Get.find<HapticsController>().loadFromStorage();
    initialRoute = await _resolveInitialRoute();
  }

  static Future<String> _resolveInitialRoute() async {
    try {
      final authRepository = Get.find<AuthRepository>();
      final token = await authRepository.getAccessToken();
      if (token == null || token.isEmpty) {
        return await _tryRestoreFromFirebase(authRepository);
      }
      final getMe = Get.find<GetMeUseCase>();
      await getMe();
      return AppRoutes.mainApp;
    } catch (_) {
      try {
        await Get.find<AuthRepository>().clearSession();
      } catch (_) {}
      return await _tryRestoreFromFirebase(Get.find<AuthRepository>());
    }
  }

  static Future<String> _tryRestoreFromFirebase(
    AuthRepository authRepository,
  ) async {
    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) return AppRoutes.onboarding;
      final idToken = await firebaseUser.getIdToken();
      if (idToken == null || idToken.isEmpty) return AppRoutes.onboarding;
      await authRepository.exchangeFirebaseSession(
        idToken: idToken,
        rememberMe: true,
      );
      await Get.find<GetMeUseCase>()();
      return AppRoutes.mainApp;
    } catch (_) {
      try {
        await Get.find<FirebaseAuthGateway>().signOut();
      } catch (_) {}
      return AppRoutes.onboarding;
    }
  }
}
