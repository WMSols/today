import 'package:get/get.dart';

import 'package:today/presentation/features/goal_input/controllers/goal_input_controller.dart';

class GoalInputBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoalInputController>(GoalInputController.new);
  }
}
