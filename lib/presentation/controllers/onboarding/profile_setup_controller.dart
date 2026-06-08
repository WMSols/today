import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/navigation/post_auth_navigation.dart';
import 'package:today/core/storage/profile_setup_storage.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';
import 'package:today/core/widgets/form/app_datetime_picker/app_datetime_picker.dart';
import 'package:today/domain/entities/profile_setup_entity.dart';
import 'package:today/presentation/controllers/settings/haptics_controller.dart';
import 'package:today/presentation/routes/route_arguments.dart';

class ProfileSetupController extends GetxController {
  ProfileSetupController(
    this._storage, {
    this.mode = ProfileSetupMode.onboarding,
  });

  final ProfileSetupStorage _storage;
  final ProfileSetupMode mode;

  static const int officeHoursMinMinutes = 0; // 12:00 AM
  static const int officeHoursMaxMinutes = 1440; // 12:00 AM (end of day)
  static const int officeHoursStepMinutes = 15;

  final wakeTime = ProfileSetupEntity.defaults.wakeTime.obs;
  final bedTime = ProfileSetupEntity.defaults.bedTime.obs;
  final officeStartMinutes = _timeToMinutes(
    ProfileSetupEntity.defaults.officeStart,
  ).obs;
  final officeEndMinutes = _timeToMinutes(
    ProfileSetupEntity.defaults.officeEnd,
  ).obs;
  final workoutWindow = ProfileSetupEntity.defaults.workoutWindow.obs;
  final deepWorkPreference = ProfileSetupEntity.defaults.deepWorkPreference.obs;
  final RxBool isSubmitting = false.obs;

  bool get isOnboarding => mode == ProfileSetupMode.onboarding;
  bool get isSettings => mode == ProfileSetupMode.settings;

  String get primaryCtaLabel => isOnboarding
      ? AppTexts.profileSetupCompleteCta
      : AppTexts.profileSetupSaveCta;

  RangeValues get officeHoursRange => RangeValues(
    officeStartMinutes.value.toDouble(),
    officeEndMinutes.value.toDouble(),
  );

  String get wakeTimeLabel => _formatTimeOfDay(wakeTime.value);
  String get bedTimeLabel => _formatTimeOfDay(bedTime.value);
  String get officeStartLabel => _formatOfficeMinutes(officeStartMinutes.value);
  String get officeEndLabel => _formatOfficeMinutes(officeEndMinutes.value);

  @override
  void onInit() {
    super.onInit();
    unawaited(_loadSavedPreferences());
  }

  Future<void> _loadSavedPreferences() async {
    final saved = await _storage.loadPreferences();
    if (saved == null) return;
    _applyEntity(
      saved,
      officeEndMinutes: _storage.decodeOfficeEndMinutes(saved.officeEnd),
    );
  }

  void _applyEntity(
    ProfileSetupEntity entity, {
    required int officeEndMinutes,
  }) {
    wakeTime.value = entity.wakeTime;
    bedTime.value = entity.bedTime;
    officeStartMinutes.value = _timeToMinutes(entity.officeStart);
    this.officeEndMinutes.value = officeEndMinutes;
    workoutWindow.value = entity.workoutWindow;
    deepWorkPreference.value = entity.deepWorkPreference;
  }

  Future<void> openWakeTimePicker() async {
    await _openTimePicker(
      title: AppTexts.profileSetupWakeUpLabel,
      initial: wakeTime.value,
      onPicked: (time) => wakeTime.value = time,
    );
  }

  Future<void> openBedTimePicker() async {
    await _openTimePicker(
      title: AppTexts.profileSetupBedtimeLabel,
      initial: bedTime.value,
      onPicked: (time) => bedTime.value = time,
    );
  }

  Future<void> _openTimePicker({
    required String title,
    required TimeOfDay initial,
    required ValueChanged<TimeOfDay> onPicked,
  }) async {
    final context = Get.context;
    if (context == null) return;

    final picked = await AppDateTimePicker.show(
      context,
      title: title,
      initial: _timeOfDayToDateTime(initial),
      mode: AppDateTimePickerMode.timeOnly,
    );
    if (picked == null) return;

    _impact();
    onPicked(TimeOfDay(hour: picked.hour, minute: picked.minute));
  }

  void onOfficeHoursChanged(RangeValues values) {
    final start = _snapOfficeMinutes(values.start.round());
    var end = _snapOfficeMinutes(values.end.round());
    if (end <= start) {
      end = (start + officeHoursStepMinutes).clamp(
        officeHoursMinMinutes,
        officeHoursMaxMinutes,
      );
    }
    officeStartMinutes.value = start;
    officeEndMinutes.value = end;
  }

  void selectWorkoutWindow(WorkoutWindow value) {
    if (workoutWindow.value == value) return;
    _impact();
    workoutWindow.value = value;
  }

  void selectDeepWorkPreference(DeepWorkPreference value) {
    if (deepWorkPreference.value == value) return;
    _impact();
    deepWorkPreference.value = value;
  }

  Future<void> onPrimaryAction() async {
    if (isOnboarding) {
      await completeSetup();
    } else {
      await saveFromSettings();
    }
  }

  Future<void> completeSetup() async {
    if (isSubmitting.value) return;
    if (!_validateOfficeHours()) return;

    isSubmitting.value = true;
    try {
      await _persistPreferences(markGateComplete: true);
      await _goToMainApp();
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> saveFromSettings() async {
    if (isSubmitting.value) return;
    if (!_validateOfficeHours()) return;

    isSubmitting.value = true;
    try {
      await _persistPreferences(markGateComplete: false);
      _impact();
      Get.back<bool>(result: true);
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> skipForNow() async {
    if (!isOnboarding || isSubmitting.value) return;
    _impact();
    isSubmitting.value = true;
    try {
      await _storage.saveDefaultsAndComplete();
      await _goToMainApp();
    } finally {
      isSubmitting.value = false;
    }
  }

  void resetToDefaults() {
    if (!isSettings) return;
    _impact();
    _applyEntity(
      ProfileSetupEntity.defaults,
      officeEndMinutes: _timeToMinutes(ProfileSetupEntity.defaults.officeEnd),
    );
  }

  ProfileSetupEntity _buildEntity() {
    return ProfileSetupEntity(
      wakeTime: wakeTime.value,
      bedTime: bedTime.value,
      officeStart: _minutesToTimeOfDay(officeStartMinutes.value),
      officeEnd: _minutesToTimeOfDay(officeEndMinutes.value),
      workoutWindow: workoutWindow.value,
      deepWorkPreference: deepWorkPreference.value,
    );
  }

  Future<void> _persistPreferences({required bool markGateComplete}) async {
    await _storage.savePreferences(
      _buildEntity(),
      officeEndMinutes: officeEndMinutes.value,
    );
    if (markGateComplete) {
      await _storage.setProfileSetupCompleted();
    }
  }

  bool _validateOfficeHours() {
    if (officeEndMinutes.value <= officeStartMinutes.value) {
      AppToast.showError(AppTexts.profileSetupOfficeHoursInvalid);
      return false;
    }
    return true;
  }

  Future<void> _goToMainApp() async {
    _impact();
    await PostAuthNavigation.goToMainApp();
  }

  void _impact() {
    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
  }

  static int _timeToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  static TimeOfDay _minutesToTimeOfDay(int minutes) {
    final hour = minutes ~/ 60;
    final minute = minutes % 60;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static int _snapOfficeMinutes(int minutes) {
    final snapped =
        ((minutes - officeHoursMinMinutes) / officeHoursStepMinutes).round() *
            officeHoursStepMinutes +
        officeHoursMinMinutes;
    return snapped.clamp(officeHoursMinMinutes, officeHoursMaxMinutes);
  }

  static DateTime _timeOfDayToDateTime(TimeOfDay time) {
    return DateTime(2024, 1, 1, time.hour, time.minute);
  }

  static String _formatTimeOfDay(TimeOfDay time) {
    return AppFormatter.timeOfDay(_timeOfDayToDateTime(time));
  }

  static String _formatOfficeMinutes(int minutes) {
    final clamped = minutes.clamp(officeHoursMinMinutes, officeHoursMaxMinutes);
    if (clamped >= officeHoursMaxMinutes) {
      return AppFormatter.timeOfDay(
        _timeOfDayToDateTime(const TimeOfDay(hour: 0, minute: 0)),
      );
    }
    return _formatTimeOfDay(_minutesToTimeOfDay(clamped));
  }
}
