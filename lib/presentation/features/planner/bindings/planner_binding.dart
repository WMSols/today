import 'package:get/get.dart';

import 'package:today/presentation/features/planner/controllers/planner_controller.dart';

class PlannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlannerController>(PlannerController.new);
  }
}
