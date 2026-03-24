import 'package:get/get.dart';

import 'package:today/presentation/features/progress/controllers/progress_controller.dart';

class ProgressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProgressController>(ProgressController.new);
  }
}
