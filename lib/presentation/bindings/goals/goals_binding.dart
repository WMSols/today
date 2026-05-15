import 'package:get/get.dart';

import 'package:today/domain/usecases/get_goal_cards_usecase.dart';
import 'package:today/presentation/controllers/goals/goal_cards_controller.dart';
import 'package:today/presentation/controllers/goals/goals_controller.dart';

class GoalsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<GoalCardsController>()) {
      Get.lazyPut<GoalCardsController>(
        () => GoalCardsController(Get.find<GetGoalCardsUseCase>()),
      );
    }
    if (!Get.isRegistered<GoalsController>()) {
      Get.lazyPut<GoalsController>(
        () => GoalsController(Get.find<GoalCardsController>()),
      );
    }
  }
}
