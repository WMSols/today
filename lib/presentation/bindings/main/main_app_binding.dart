import 'package:get/get.dart';

import 'package:today/presentation/controllers/main/main_app_controller.dart';

class MainAppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainAppController>(MainAppController.new);
  }
}
