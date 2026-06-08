import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:today/core/constants/storage_keys.dart';
import 'package:today/domain/entities/profile_setup_entity.dart';

/// Local persistence for profile setup preferences (onboarding gate + values).
class ProfileSetupStorage {
  ProfileSetupStorage(this._prefs);

  final SharedPreferences _prefs;

  Future<bool> hasCompletedProfileSetup() async {
    return _prefs.getBool(StorageKeys.hasCompletedProfileSetup) ?? false;
  }

  Future<void> setProfileSetupCompleted() async {
    await _prefs.setBool(StorageKeys.hasCompletedProfileSetup, true);
  }

  Future<void> savePreferences(
    ProfileSetupEntity entity, {
    required int officeEndMinutes,
  }) async {
    await _prefs.setString(
      StorageKeys.profileSetupWakeTime,
      _encodeTime(entity.wakeTime),
    );
    await _prefs.setString(
      StorageKeys.profileSetupBedTime,
      _encodeTime(entity.bedTime),
    );
    await _prefs.setString(
      StorageKeys.profileSetupOfficeStart,
      _encodeTime(entity.officeStart),
    );
    await _prefs.setString(
      StorageKeys.profileSetupOfficeEnd,
      _encodeOfficeEndMinutes(officeEndMinutes),
    );
    await _prefs.setString(
      StorageKeys.profileSetupWorkoutWindow,
      entity.workoutWindow.name,
    );
    await _prefs.setString(
      StorageKeys.profileSetupDeepWork,
      entity.deepWorkPreference.name,
    );
  }

  Future<ProfileSetupEntity?> loadPreferences() async {
    final wake = _decodeTime(
      _prefs.getString(StorageKeys.profileSetupWakeTime),
    );
    final bed = _decodeTime(_prefs.getString(StorageKeys.profileSetupBedTime));
    final officeStart = _decodeTime(
      _prefs.getString(StorageKeys.profileSetupOfficeStart),
    );
    final officeEnd = _decodeOfficeEnd(
      _prefs.getString(StorageKeys.profileSetupOfficeEnd),
    );
    final workoutRaw = _prefs.getString(StorageKeys.profileSetupWorkoutWindow);
    final deepWorkRaw = _prefs.getString(StorageKeys.profileSetupDeepWork);

    if (wake == null ||
        bed == null ||
        officeStart == null ||
        officeEnd == null ||
        workoutRaw == null ||
        deepWorkRaw == null) {
      return null;
    }

    final workout = _parseEnum(workoutRaw, WorkoutWindow.values);
    final deepWork = _parseEnum(deepWorkRaw, DeepWorkPreference.values);

    if (workout == null || deepWork == null) return null;

    return ProfileSetupEntity(
      wakeTime: wake,
      bedTime: bed,
      officeStart: officeStart,
      officeEnd: officeEnd,
      workoutWindow: workout,
      deepWorkPreference: deepWork,
    );
  }

  Future<void> saveDefaultsAndComplete() async {
    await savePreferences(
      ProfileSetupEntity.defaults,
      officeEndMinutes:
          ProfileSetupEntity.defaults.officeEnd.hour * 60 +
          ProfileSetupEntity.defaults.officeEnd.minute,
    );
    await setProfileSetupCompleted();
  }

  /// Maps stored office end to slider minutes (supports end-of-day midnight).
  int decodeOfficeEndMinutes(TimeOfDay officeEnd) {
    final raw = _prefs.getString(StorageKeys.profileSetupOfficeEnd);
    if (raw == _officeEndMidnightToken) return 1440;
    return officeEnd.hour * 60 + officeEnd.minute;
  }

  static const String _officeEndMidnightToken = '24:00';

  static String _encodeOfficeEndMinutes(int minutes) {
    if (minutes >= 1440) return _officeEndMidnightToken;
    return _encodeTime(TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60));
  }

  static String _encodeTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static TimeOfDay? _decodeOfficeEnd(String? raw) {
    if (raw == _officeEndMidnightToken) {
      return const TimeOfDay(hour: 0, minute: 0);
    }
    return _decodeTime(raw);
  }

  static TimeOfDay? _decodeTime(String? raw) {
    if (raw == null || !raw.contains(':')) return null;
    final parts = raw.split(':');
    if (parts.length != 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  static T? _parseEnum<T extends Enum>(String? raw, List<T> values) {
    if (raw == null) return null;
    for (final value in values) {
      if (value.name == raw) return value;
    }
    return null;
  }
}
