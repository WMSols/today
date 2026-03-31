import 'package:get/get.dart';

import 'package:today/domain/usecases/get_active_goal_tasks_usecase.dart';
import 'package:today/domain/usecases/get_goal_cards_usecase.dart';
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
      () => HomeController(Get.find<GetActiveGoalTasksUseCase>()),
    );
    Get.lazyPut<SettingsController>(SettingsController.new);
  }
}
