import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:today/core/theme/app_accent_color.dart';
import 'package:today/presentation/controllers/settings/haptics_controller.dart';

class AccentColorController extends GetxController {
  AccentColorController();

  static const _storageKey = 'app_accent_color';

  AppAccentColor _accent = AppAccentColor.defaultValue;

  AppAccentColor get accent => _accent;

  Future<void> loadFromStorage() async {
    final prefs = Get.find<SharedPreferences>();
    _accent =
        AppAccentColor.tryParse(prefs.getString(_storageKey)) ??
        AppAccentColor.defaultValue;
    update();
  }

  Future<void> setAccent(AppAccentColor value) async {
    if (_accent == value) return;
    _accent = value;
    update();
    await Get.find<SharedPreferences>().setString(_storageKey, value.name);
    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
  }
}
