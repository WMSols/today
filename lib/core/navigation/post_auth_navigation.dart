import 'package:get/get.dart';
import 'package:today/core/storage/initial_plan_storage.dart';
import 'package:today/core/storage/profile_setup_storage.dart';
import 'package:today/presentation/controllers/animation/app_animation_controller.dart';
import 'package:today/presentation/routes/app_routes.dart';

/// Decides post-auth onboarding gates before [MainAppScreen].
abstract class PostAuthNavigation {
  static Future<void> goAfterAuth() async {
    final initialPlanStorage = Get.find<InitialPlanStorage>();
    if (!await initialPlanStorage.hasSeenPlanStatusGate()) {
      await _offAllTo(AppRoutes.planStatus);
      return;
    }

    final profileSetupStorage = Get.find<ProfileSetupStorage>();
    if (!await profileSetupStorage.hasCompletedProfileSetup()) {
      await _offAllTo(AppRoutes.profileSetup);
      return;
    }

    await goToMainApp();
  }

  static Future<void> goToMainApp() async {
    if (Get.isRegistered<AppAnimationController>()) {
      await Get.find<AppAnimationController>().offAllToMainApp<void>();
      return;
    }
    await Get.offAllNamed<void>(AppRoutes.mainApp);
  }

  static Future<void> _offAllTo(String routeName) async {
    if (Get.isRegistered<AppAnimationController>()) {
      await Get.find<AppAnimationController>().offAllFromSplash<void>(
        routeName,
      );
      return;
    }
    await Get.offAllNamed<void>(routeName);
  }
}
