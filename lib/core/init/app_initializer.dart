import 'package:today/app/routes/app_routes.dart';
import 'package:today/core/config/env_config.dart';
import 'package:today/core/init/app_system_ui.dart';
import 'package:today/di/app_binding.dart';

/// Handles async app bootstrap: env, DI, and initial route resolution.
abstract class AppInitializer {
  static String initialRoute = AppRoutes.onboarding;

  static Future<void> init() async {
    await EnvConfig.load();
    AppSystemUi.setOverlayStyle();
    AppBinding().dependencies();
    initialRoute = _resolveInitialRoute();
  }

  static String _resolveInitialRoute() {
    // Keep onboarding as the default entry until auth/local state is added.
    return AppRoutes.onboarding;
  }
}
