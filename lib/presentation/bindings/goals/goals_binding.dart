import 'package:get/get.dart';

import 'package:today/presentation/controllers/goals/goals_controller.dart';

class GoalsBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<GoalsController>()) return;
    Get.lazyPut<GoalsController>(() => GoalsController(Get.find()));
  }
}
