import 'package:get/get.dart';

import 'package:today/core/auth/firebase_auth_gateway.dart';
import 'package:today/core/storage/profile_setup_storage.dart';
import 'package:today/domain/usecases/create_goal_usecase.dart';
import 'package:today/domain/usecases/complete_task_usecase.dart';
import 'package:today/domain/usecases/delete_goal_usecase.dart';
import 'package:today/domain/usecases/get_active_goal_tasks_usecase.dart';
import 'package:today/domain/usecases/get_goal_cards_usecase.dart';
import 'package:today/domain/usecases/get_goal_history_usecase.dart';
import 'package:today/domain/usecases/skip_task_usecase.dart';
import 'package:today/domain/usecases/get_analytics_dashboard_usecase.dart';
import 'package:today/domain/usecases/delete_calendar_event_usecase.dart';
import 'package:today/domain/usecases/get_weekly_calendar_usecase.dart';
import 'package:today/domain/usecases/delete_goal_task_usecase.dart';
import 'package:today/domain/usecases/update_calendar_event_usecase.dart';
import 'package:today/domain/usecases/update_goal_task_usecase.dart';
import 'package:today/core/storage/today_schedule_store.dart';
import 'package:today/domain/repositories/home_today_tasks_repository.dart';
import 'package:today/domain/repositories/auth_repository.dart';
import 'package:today/presentation/controllers/analytics/analytics_controller.dart';
import 'package:today/presentation/controllers/goals/goal_cards_controller.dart';
import 'package:today/presentation/controllers/goals/goals_controller.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';
import 'package:today/presentation/controllers/main/main_app_controller.dart';
import 'package:today/presentation/controllers/settings/settings_controller.dart';

class MainAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainAppController>(MainAppController.new);
    if (!Get.isRegistered<GoalCardsController>()) {
      Get.lazyPut<GoalCardsController>(
        () => GoalCardsController(Get.find<GetGoalCardsUseCase>()),
      );
    }
    Get.lazyPut<GoalsController>(
      () => GoalsController(Get.find<GoalCardsController>()),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(
        Get.find<GoalCardsController>(),
        Get.find<GetActiveGoalTasksUseCase>(),
        Get.find<CreateGoalUseCase>(),
        Get.find<CompleteTaskUseCase>(),
        Get.find<SkipTaskUseCase>(),
        Get.find<GetGoalHistoryUseCase>(),
        Get.find<DeleteGoalUseCase>(),
        Get.find<GetWeeklyCalendarUseCase>(),
        Get.find<TodayScheduleStore>(),
        Get.find<HomeTodayTasksRepository>(),
        Get.find<DeleteCalendarEventUseCase>(),
        Get.find<UpdateCalendarEventUseCase>(),
        Get.find<UpdateGoalTaskUseCase>(),
        Get.find<DeleteGoalTaskUseCase>(),
      ),
    );
    Get.lazyPut<AnalyticsController>(
      () => AnalyticsController(Get.find<GetAnalyticsDashboardUseCase>()),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        Get.find<AuthRepository>(),
        Get.find<FirebaseAuthGateway>(),
        Get.find<ProfileSetupStorage>(),
      ),
    );
  }
}
