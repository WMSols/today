import 'package:get/get.dart';
import 'package:today/core/storage/initial_plan_storage.dart';
import 'package:today/presentation/controllers/animation/app_animation_controller.dart';
import 'package:today/presentation/routes/app_routes.dart';

/// Decides whether authenticated users see [PlanStatusScreen] or [MainAppScreen].
abstract class PostAuthNavigation {
  static Future<void> goAfterAuth() async {
    final storage = Get.find<InitialPlanStorage>();
    if (!await storage.hasSeenPlanStatusGate()) {
      if (Get.isRegistered<AppAnimationController>()) {
        await Get.find<AppAnimationController>().offAllFromSplash<void>(
          AppRoutes.planStatus,
        );
        return;
      }
      await Get.offAllNamed<void>(AppRoutes.planStatus);
      return;
    }

    if (Get.isRegistered<AppAnimationController>()) {
      await Get.find<AppAnimationController>().offAllToMainApp<void>();
      return;
    }
    await Get.offAllNamed<void>(AppRoutes.mainApp);
  }
}
