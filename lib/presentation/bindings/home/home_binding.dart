import 'package:get/get.dart';

import 'package:today/domain/usecases/create_goal_usecase.dart';
import 'package:today/domain/usecases/complete_task_usecase.dart';
import 'package:today/domain/usecases/delete_goal_usecase.dart';
import 'package:today/domain/usecases/get_active_goal_tasks_usecase.dart';
import 'package:today/domain/usecases/get_goal_cards_usecase.dart';
import 'package:today/domain/usecases/get_goal_history_usecase.dart';
import 'package:today/domain/usecases/skip_task_usecase.dart';
import 'package:today/domain/usecases/get_weekly_calendar_usecase.dart';
import 'package:today/domain/repositories/home_today_tasks_repository.dart';
import 'package:today/domain/usecases/get_home_today_tasks_usecase.dart';
import 'package:today/presentation/controllers/goals/goal_cards_controller.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<GoalCardsController>()) {
      Get.lazyPut<GoalCardsController>(
        () => GoalCardsController(Get.find<GetGoalCardsUseCase>()),
      );
    }
    if (!Get.isRegistered<HomeController>()) {
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
          Get.find<GetHomeTodayTasksUseCase>(),
          Get.find<HomeTodayTasksRepository>(),
        ),
      );
    }
  }
}
