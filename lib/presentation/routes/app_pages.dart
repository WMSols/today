import 'package:get/get.dart';

import 'package:today/presentation/controllers/animation/app_animation_controller.dart';
import 'package:today/presentation/bindings/splash/splash_binding.dart';
import 'package:today/presentation/screens/splash/splash_screen.dart';
import 'package:today/presentation/bindings/auth/auth_binding.dart';
import 'package:today/presentation/screens/auth/auth_screen.dart';
import 'package:today/presentation/bindings/goals/goals_binding.dart';
import 'package:today/presentation/screens/goals/goals_screen.dart';
import 'package:today/presentation/screens/home/active_goal_details_screen.dart';
import 'package:today/presentation/bindings/home/home_binding.dart';
import 'package:today/presentation/screens/home/home_calendar_screen.dart';
import 'package:today/presentation/screens/home/home_screen.dart';
import 'package:today/presentation/screens/home/todays_tasks_screen.dart';
import 'package:today/presentation/bindings/main/main_app_binding.dart';
import 'package:today/presentation/screens/main/main_app_screen.dart';
import 'package:today/presentation/bindings/settings/notifications_binding.dart';
import 'package:today/presentation/screens/settings/notifications_screen.dart';
import 'package:today/presentation/bindings/onboarding/onboarding_binding.dart';
import 'package:today/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:today/presentation/screens/planner/creating_plan_screen.dart';
import 'package:today/presentation/bindings/planner/planner_binding.dart';
import 'package:today/presentation/screens/planner/planner_screen.dart';
import 'package:today/presentation/routes/app_routes.dart';
import 'package:today/presentation/bindings/settings/settings_binding.dart';
import 'package:today/presentation/screens/settings/settings_screen.dart';
import 'package:today/presentation/bindings/settings/subscription_binding.dart';
import 'package:today/presentation/screens/settings/subscription_screen.dart';

abstract class AppPages {
  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.homeCalendar,
      page: () => const HomeCalendarScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.todaysTasks,
      page: () => const TodaysTasksScreen(),
      binding: HomeBinding(),
      transition: AppAnimationController.pushTransition,
      transitionDuration: AppAnimationController.pushDuration,
      curve: AppAnimationController.pushCurve,
    ),
    GetPage(
      name: AppRoutes.activeGoalDetails,
      page: () => const ActiveGoalDetailsScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.mainApp,
      page: () => const MainAppScreen(),
      binding: MainAppBinding(),
    ),
    GetPage(
      name: AppRoutes.planner,
      page: () => const PlannerScreen(),
      binding: PlannerBinding(),
    ),
    GetPage(
      name: AppRoutes.creatingPlan,
      page: () => const CreatingPlanScreen(),
      binding: PlannerBinding(),
    ),
    GetPage(
      name: AppRoutes.subscription,
      page: () => const SubscriptionScreen(),
      binding: SubscriptionBinding(),
    ),
    GetPage(
      name: AppRoutes.goals,
      page: () => const GoalsScreen(),
      binding: GoalsBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
      binding: NotificationsBinding(),
    ),
  ];
}
