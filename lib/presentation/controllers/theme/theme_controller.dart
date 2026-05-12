import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:today/presentation/controllers/feedback/haptics_controller.dart';

/// User-selectable theme; maps to Flutter [ThemeMode].
enum AppThemePreference {
  system,
  light,
  dark;

  ThemeMode get asThemeMode => switch (this) {
    AppThemePreference.system => ThemeMode.system,
    AppThemePreference.light => ThemeMode.light,
    AppThemePreference.dark => ThemeMode.dark,
  };

  static AppThemePreference? tryParse(String? raw) {
    if (raw == null) return null;
    for (final v in AppThemePreference.values) {
      if (v.name == raw) return v;
    }
    return null;
  }
}

class ThemeController extends GetxController {
  ThemeController();

  static const _storageKey = 'app_theme_preference';

  AppThemePreference _preference = AppThemePreference.system;

  ThemeMode get themeMode => _preference.asThemeMode;

  AppThemePreference get preference => _preference;

  Future<void> loadFromStorage() async {
    final prefs = Get.find<SharedPreferences>();
    _preference =
        AppThemePreference.tryParse(prefs.getString(_storageKey)) ??
        AppThemePreference.system;
    update();
  }

  Future<void> setPreference(AppThemePreference value) async {
    if (_preference == value) return;
    _preference = value;
    update();
    await Get.find<SharedPreferences>().setString(_storageKey, value.name);
    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
  }
}
