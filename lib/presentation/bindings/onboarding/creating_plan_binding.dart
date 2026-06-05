import 'package:get/get.dart';

import 'package:today/core/storage/initial_plan_storage.dart';
import 'package:today/presentation/controllers/onboarding/creating_plan_controller.dart';

class CreatingPlanBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<CreatingPlanController>()) {
      Get.delete<CreatingPlanController>(force: true);
    }
    final flow = CreatingPlanController.flowFromArguments(Get.arguments);
    Get.put(CreatingPlanController(Get.find<InitialPlanStorage>(), flow: flow));
  }
}
