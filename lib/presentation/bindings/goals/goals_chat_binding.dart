import 'package:get/get.dart';

import 'package:today/presentation/controllers/goals/goals_chat_controller.dart';

class GoalsChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoalsChatController>(GoalsChatController.new);
  }
}
