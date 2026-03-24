import 'package:get/get.dart';

import 'package:today/app/routes/app_routes.dart';
import 'package:today/presentation/features/dashboard/bindings/dashboard_binding.dart';
import 'package:today/presentation/features/dashboard/screens/dashboard_screen.dart';
import 'package:today/presentation/features/goal_input/bindings/goal_input_binding.dart';
import 'package:today/presentation/features/goal_input/screens/goal_input_screen.dart';
import 'package:today/presentation/features/onboarding/bindings/onboarding_binding.dart';
import 'package:today/presentation/features/onboarding/screens/onboarding_screen.dart';
import 'package:today/presentation/features/planner/bindings/planner_binding.dart';
import 'package:today/presentation/features/planner/screens/planner_screen.dart';
import 'package:today/presentation/features/progress/bindings/progress_binding.dart';
import 'package:today/presentation/features/progress/screens/progress_screen.dart';

abstract class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.goalInput,
      page: () => const GoalInputScreen(),
      binding: GoalInputBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardScreen(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.planner,
      page: () => const PlannerScreen(),
      binding: PlannerBinding(),
    ),
    GetPage(
      name: AppRoutes.progress,
      page: () => const ProgressScreen(),
      binding: ProgressBinding(),
    ),
  ];
}
