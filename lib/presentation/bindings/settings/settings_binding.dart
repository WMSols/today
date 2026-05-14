import 'package:get/get.dart';

import 'package:today/core/auth/firebase_auth_gateway.dart';
import 'package:today/domain/repositories/auth_repository.dart';
import 'package:today/domain/usecases/get_me_usecase.dart';
import 'package:today/presentation/controllers/settings/settings_controller.dart';
import 'package:today/presentation/controllers/settings/subscription_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SettingsController>()) {
      Get.lazyPut<SettingsController>(
        () => SettingsController(
          Get.find<GetMeUseCase>(),
          Get.find<AuthRepository>(),
          Get.find<FirebaseAuthGateway>(),
        ),
      );
    }
    if (!Get.isRegistered<SubscriptionController>()) {
      Get.lazyPut<SubscriptionController>(
        () => SubscriptionController(Get.find()),
      );
    }
  }
}
