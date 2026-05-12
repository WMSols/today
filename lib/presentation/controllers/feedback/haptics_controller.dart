import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

/// Global haptic preference and helpers. Registered in [AppInitializer].
class HapticsController extends GetxController {
  static const _prefKey = 'haptics_enabled';

  final RxBool enabled = true.obs;

  bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  Future<void> loadFromStorage() async {
    final prefs = Get.find<SharedPreferences>();
    final stored = prefs.getBool(_prefKey);
    enabled.value = stored ?? true;
  }

  Future<void> setEnabled(bool value) async {
    final wasEnabled = enabled.value;
    enabled.value = value;
    await Get.find<SharedPreferences>().setBool(_prefKey, value);
    if (value && !wasEnabled) {
      impact();
    }
  }

  void _invoke(
    String kind,
    VoidCallback play, {
    int androidMotorMs = 0,
    int? androidAmplitude,
  }) {
    if (!enabled.value) return;
    play();
    if (androidMotorMs > 0 && _isAndroid) {
      unawaited(_androidMotorPulse(androidMotorMs, androidAmplitude));
    }
  }

  Future<void> _androidMotorPulse(int durationMs, int? amplitude) async {
    if (!enabled.value) return;
    try {
      if (!await Vibration.hasVibrator()) return;
      if (amplitude != null && await Vibration.hasAmplitudeControl()) {
        await Vibration.vibrate(duration: durationMs, amplitude: amplitude);
      } else {
        await Vibration.vibrate(duration: durationMs);
      }
    } catch (_) {}
  }

  void impact() => _invoke(
        'impact',
        HapticFeedback.mediumImpact,
        androidMotorMs: 65,
        androidAmplitude: 210,
      );
}
