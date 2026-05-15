import 'package:get/get.dart';

import 'package:today/domain/usecases/get_subscription_plans_usecase.dart';
import 'package:today/presentation/controllers/settings/subscription_controller.dart';

class SubscriptionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionController>(
      () => SubscriptionController(Get.find<GetSubscriptionPlansUseCase>()),
    );
  }
}
