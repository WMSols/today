import 'package:get/get.dart';

import 'package:today/domain/usecases/create_goal_usecase.dart';
import 'package:today/domain/usecases/complete_task_usecase.dart';
import 'package:today/domain/usecases/delete_goal_usecase.dart';
import 'package:today/domain/usecases/get_active_goal_tasks_usecase.dart';
import 'package:today/domain/usecases/get_goal_cards_usecase.dart';
import 'package:today/domain/usecases/get_goal_history_usecase.dart';
import 'package:today/domain/usecases/skip_task_usecase.dart';
import 'package:today/domain/usecases/get_me_usecase.dart';
import 'package:today/domain/repositories/auth_repository.dart';
import 'package:today/presentation/controllers/goals/goals_controller.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';
import 'package:today/presentation/controllers/main/main_app_controller.dart';
import 'package:today/presentation/controllers/settings/settings_controller.dart';

class MainAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainAppController>(MainAppController.new);
    Get.lazyPut<GoalsController>(
      () => GoalsController(Get.find<GetGoalCardsUseCase>()),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(
        Get.find<GetActiveGoalTasksUseCase>(),
        Get.find<GetGoalCardsUseCase>(),
        Get.find<CreateGoalUseCase>(),
        Get.find<CompleteTaskUseCase>(),
        Get.find<SkipTaskUseCase>(),
        Get.find<GetGoalHistoryUseCase>(),
        Get.find<DeleteGoalUseCase>(),
      ),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        Get.find<GetMeUseCase>(),
        Get.find<AuthRepository>(),
      ),
    );
  }
}
