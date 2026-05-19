import 'package:intl/intl.dart';

import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

/// Formatters: display formatting only .
/// For null/empty/parsing helpers use [AppHelper]; for validation use [AppValidator].
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
      AppTexts.monJan,
      AppTexts.monFeb,
      AppTexts.monMar,
      AppTexts.monApr,
      AppTexts.monMay,
      AppTexts.monJun,
      AppTexts.monJul,
      AppTexts.monAug,
      AppTexts.monSep,
      AppTexts.monOct,
      AppTexts.monNov,
      AppTexts.monDec,
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

  /// Full month name by month index (1–12).
  static String monthNameFull(int month) {
    const names = [
      AppTexts.monthJanuary,
      AppTexts.monthFebruary,
      AppTexts.monthMarch,
      AppTexts.monthApril,
      AppTexts.monthMay,
      AppTexts.monthJune,
      AppTexts.monthJuly,
      AppTexts.monthAugust,
      AppTexts.monthSeptember,
      AppTexts.monthOctober,
      AppTexts.monthNovember,
      AppTexts.monthDecember,
    ];
    return names[month - 1];
  }

  /// Time-of-day greeting for the home screen (morning, afternoon, evening, night).
  static String timeOfDayGreeting([DateTime? when]) {
    final hour = (when ?? DateTime.now()).hour;
    if (hour >= 5 && hour < 12) return AppTexts.greetingMorning;
    if (hour >= 12 && hour < 17) return AppTexts.greetingAfternoon;
    if (hour >= 17 && hour < 21) return AppTexts.greetingEvening;
    return AppTexts.greetingNight;
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
