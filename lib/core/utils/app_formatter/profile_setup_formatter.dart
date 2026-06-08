import 'package:flutter/material.dart';

import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/domain/entities/profile_setup_entity.dart';

/// Display formatting for profile setup preferences.
abstract class ProfileSetupFormatter {
  ProfileSetupFormatter._();

  static const int _endOfDayMinutes = 1440;

  /// e.g. "6:30 AM wake · 9:00 AM–5:00 PM office"
  static String settingsSummary(
    ProfileSetupEntity entity, {
    required int officeEndMinutes,
  }) {
    final wake = _formatTimeOfDay(entity.wakeTime);
    final officeStart = _formatTimeOfDay(entity.officeStart);
    final officeEnd = _formatOfficeEndMinutes(officeEndMinutes);
    return '$wake wake · $officeStart–$officeEnd office';
  }

  static String _formatTimeOfDay(TimeOfDay time) {
    return AppFormatter.timeOfDay(DateTime(2024, 1, 1, time.hour, time.minute));
  }

  static String _formatOfficeEndMinutes(int minutes) {
    if (minutes >= _endOfDayMinutes) {
      return _formatTimeOfDay(const TimeOfDay(hour: 0, minute: 0));
    }
    return _formatTimeOfDay(
      TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60),
    );
  }
}
