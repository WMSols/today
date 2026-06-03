import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:today/presentation/controllers/settings/haptics_controller.dart';

/// Global vacation-mode preference. Registered in [AppInitializer].
class VacationModeController extends GetxController {
  static const _prefKey = 'vacation_mode_enabled';

  final RxBool enabled = false.obs;

  Future<void> loadFromStorage() async {
    final prefs = Get.find<SharedPreferences>();
    enabled.value = prefs.getBool(_prefKey) ?? false;
  }

  Future<void> setEnabled(bool value) async {
    if (enabled.value == value) return;
    enabled.value = value;
    await Get.find<SharedPreferences>().setBool(_prefKey, value);
    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
  }
}
