import 'package:get/get.dart';

import 'package:today/core/auth/firebase_auth_gateway.dart';
import 'package:today/domain/repositories/auth_repository.dart';
import 'package:today/presentation/controllers/auth/auth_controller.dart';
import 'package:today/presentation/controllers/onboarding/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(OnboardingController.new);
    Get.lazyPut<AuthController>(
      () => AuthController(
        Get.find<AuthRepository>(),
        Get.find<FirebaseAuthGateway>(),
      ),
    );
  }
}
