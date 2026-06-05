import 'package:get/get.dart';

import 'package:today/core/storage/initial_plan_storage.dart';
import 'package:today/presentation/controllers/onboarding/plan_status_controller.dart';

class PlanStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlanStatusController>(
      () => PlanStatusController(Get.find<InitialPlanStorage>()),
    );
  }
}
