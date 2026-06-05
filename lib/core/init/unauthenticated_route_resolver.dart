import 'package:get/get.dart';

import 'package:today/core/storage/initial_plan_storage.dart';
import 'package:today/presentation/routes/app_routes.dart';

/// Cold-start destination when there is no valid API session.
abstract class UnauthenticatedRouteResolver {
  static Future<String> resolve() async {
    final storage = Get.find<InitialPlanStorage>();
    if (!await storage.hasCompletedOnboarding()) {
      return AppRoutes.onboarding;
    }
    if (!await storage.hasCompletedInitialPlanFlow()) {
      return AppRoutes.createInitialPlan;
    }
    return AppRoutes.auth;
  }
}
