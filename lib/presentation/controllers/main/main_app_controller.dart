import 'package:get/get.dart';

import 'package:today/presentation/controllers/feedback/haptics_controller.dart';

class MainAppController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;

  void selectTab(int index) {
    if (index != selectedTabIndex.value &&
        Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
    selectedTabIndex.value = index;
  }
}
