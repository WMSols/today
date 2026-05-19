import 'package:get/get.dart';

import 'package:today/presentation/controllers/settings/haptics_controller.dart';

class MainAppController extends GetxController {
  static const int homeTabIndex = 0;
  static const int goalsTabIndex = 1;
  static const int statsTabIndex = 2;
  static const int settingsTabIndex = 3;

  final RxInt selectedTabIndex = 0.obs;

  void selectTab(int index) {
    if (index != selectedTabIndex.value &&
        Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
    selectedTabIndex.value = index;
  }

  void openStatsTab() => selectTab(statsTabIndex);
}
