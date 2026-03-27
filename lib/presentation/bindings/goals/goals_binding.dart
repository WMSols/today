import 'package:get/get.dart';

import 'package:today/presentation/controllers/goals/goals_controller.dart';

class GoalsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoalsController>(() => GoalsController(Get.find()));
  }
}
