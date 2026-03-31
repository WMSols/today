import 'package:get/get.dart';

import 'package:today/presentation/controllers/settings/settings_controller.dart';
import 'package:today/presentation/controllers/settings/subscription_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SettingsController>()) {
      Get.lazyPut<SettingsController>(SettingsController.new);
    }
    if (!Get.isRegistered<SubscriptionController>()) {
      Get.lazyPut<SubscriptionController>(
        () => SubscriptionController(Get.find()),
      );
    }
  }
}
