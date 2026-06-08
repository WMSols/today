import 'package:get/get.dart';

import 'package:today/core/storage/profile_setup_storage.dart';
import 'package:today/presentation/controllers/onboarding/profile_setup_controller.dart';
import 'package:today/presentation/routes/route_arguments.dart';

class ProfileSetupBinding extends Bindings {
  @override
  void dependencies() {
    if (Get.isRegistered<ProfileSetupController>()) {
      Get.delete<ProfileSetupController>(force: true);
    }
    Get.put<ProfileSetupController>(
      ProfileSetupController(
        Get.find<ProfileSetupStorage>(),
        mode: _resolveMode(),
      ),
    );
  }

  static ProfileSetupMode _resolveMode() {
    final args = Get.arguments;
    if (args is Map) {
      final mode = args[ProfileSetupRouteArgs.mode];
      if (mode == ProfileSetupMode.settings) {
        return ProfileSetupMode.settings;
      }
    }
    return ProfileSetupMode.onboarding;
  }
}
