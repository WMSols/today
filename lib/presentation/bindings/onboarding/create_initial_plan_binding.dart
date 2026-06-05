import 'package:get/get.dart';

import 'package:today/core/storage/initial_plan_storage.dart';
import 'package:today/presentation/controllers/onboarding/create_initial_plan_controller.dart';

class CreateInitialPlanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateInitialPlanController>(
      () => CreateInitialPlanController(Get.find<InitialPlanStorage>()),
    );
  }
}
