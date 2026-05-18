import 'package:get/get.dart';

import 'package:today/presentation/controllers/animation/app_animation_controller.dart';

/// Registers controllers when [GetMaterialApp] starts (after [ThemeController] from [main]).
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppAnimationController>(AppAnimationController.new);
  }
}
