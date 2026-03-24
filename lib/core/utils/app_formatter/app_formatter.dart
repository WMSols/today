import 'package:intl/intl.dart';

import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

/// Formatters: display formatting only .
/// For null/empty/parsing helpers use [AppHelper]; for validation use [AppValidators].
class AppFormatter {
  AppFormatter._();

  /// Full date-time string: "EEE MMM dd yyyy - h:mm a" (e.g. Tue Jun 21 2005 - 10:00 PM).
  static String dateTime(DateTime timestamp) {
    final datePart = DateFormat('EEE MMM dd yyyy').format(timestamp);
    final timePart = DateFormat('h:mm a').format(timestamp);
    return '$datePart - $timePart';
  }

  /// Short date string for pickers: "Jan 15, 2025".
  static String shortDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  /// Full day name by weekday (1=Mon..7=Sun): Monday, Tuesday, ...
  static String dayNameFull(int weekday) {
    const names = [
      AppTexts.dayMonday,
      AppTexts.dayTuesday,
      AppTexts.dayWednesday,
      AppTexts.dayThursday,
      AppTexts.dayFriday,
      AppTexts.daySaturday,
      AppTexts.daySunday,
    ];
    return names[weekday - 1];
  }

  /// Short day name by weekday (1=Mon..7=Sun): Mon, Tue, ...
  static String dayNameShort(int weekday) {
    const names = [
      AppTexts.dayMon,
      AppTexts.dayTue,
      AppTexts.dayWed,
      AppTexts.dayThu,
      AppTexts.dayFri,
      AppTexts.daySat,
      AppTexts.daySun,
    ];
    return names[weekday - 1];
  }
}
