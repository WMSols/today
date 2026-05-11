import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:today/presentation/routes/app_routes.dart';
import 'package:today/core/config/env_config.dart';
import 'package:today/core/init/app_system_ui.dart';
import 'package:today/di/app_binding.dart';
import 'package:today/domain/usecases/get_me_usecase.dart';
import 'package:today/domain/repositories/auth_repository.dart';
import 'package:today/presentation/controllers/theme/theme_controller.dart';

/// Handles async app bootstrap: env, DI, and initial route resolution.
abstract class AppInitializer {
  static String initialRoute = AppRoutes.onboarding;

  static Future<void> init() async {
    await EnvConfig.load();
    AppSystemUi.setOverlayForPlatformBrightness();
    AppBinding().dependencies();
    await Get.putAsync<SharedPreferences>(
      SharedPreferences.getInstance,
      permanent: true,
    );
    Get.put<ThemeController>(ThemeController(), permanent: true);
    await Get.find<ThemeController>().loadFromStorage();
    initialRoute = await _resolveInitialRoute();
  }

  static Future<String> _resolveInitialRoute() async {
    try {
      final authRepository = Get.find<AuthRepository>();
      final token = await authRepository.getAccessToken();
      if (token == null || token.isEmpty) return AppRoutes.onboarding;
      final getMe = Get.find<GetMeUseCase>();
      await getMe();
      return AppRoutes.mainApp;
    } catch (_) {
      try {
        await Get.find<AuthRepository>().clearSession();
      } catch (_) {}
      return AppRoutes.onboarding;
    }
  }
}
