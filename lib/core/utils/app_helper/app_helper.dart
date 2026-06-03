import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';

enum HomeDailyCalendarActivityLevel { none, success, warning, error }

class AppHelper {
  AppHelper._();

  static const double successThreshold = 0.8;
  static const double warningThreshold = 0.4;

  /// Start of tomorrow (midnight). Use for date picker min/default.
  static DateTime get tomorrow {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1);
  }

  /// Parses [value] as DateTime. Handles ISO string (e.g. 2025-06-21T22:00:00) or date-only (yyyy-mm-dd).
  static DateTime? parseDateTimeOrNull(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final s = value.trim();
    final dt = DateTime.tryParse(s);
    if (dt != null) return dt;
    final parts = s.split('-');
    if (parts.length >= 3) {
      final y = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final d = int.tryParse(parts[2].split('T').first.split(' ').first);
      if (y != null && m != null && d != null) {
        return DateTime(y, m, d);
      }
    }
    return null;
  }

  /// Returns true if [value] is null or empty/whitespace-only.
  static bool isNullOrEmpty(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// Returns true if [value] is not null and has non-whitespace content.
  static bool isNotNullOrEmpty(String? value) {
    return !isNullOrEmpty(value);
  }

  /// Parses a comma-separated string into a list of trimmed non-empty strings.
  static List<String> parseCommaSeparatedList(String? value) {
    if (value == null || value.trim().isEmpty) return const [];
    return value
        .trim()
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  /// Iconsax icon inferred from [title] keywords until API exposes goal category.
  static IconData goalIconForTitle(String title) {
    final normalized = title.toLowerCase();
    if (_titleMatches(normalized, const [
      'run',
      'cardio',
      'workout',
      'gym',
      'exercise',
      'walk',
      'jog',
      'fitness',
      'sport',
    ])) {
      return Iconsax.activity;
    }
    if (_titleMatches(normalized, const [
      'read',
      'book',
      'page',
      'study',
      'learn',
      'course',
    ])) {
      return Iconsax.book;
    }
    if (_titleMatches(normalized, const [
      'meditat',
      'yoga',
      'mindful',
      'breath',
      'calm',
      'relax',
    ])) {
      return Iconsax.heart;
    }
    if (_titleMatches(normalized, const ['sleep', 'rest', 'bed'])) {
      return Iconsax.moon;
    }
    if (_titleMatches(normalized, const ['water', 'hydrat', 'drink'])) {
      return Iconsax.bubble;
    }
    if (_titleMatches(normalized, const [
      'diet',
      'eat',
      'food',
      'meal',
      'nutrition',
      'calorie',
    ])) {
      return Iconsax.cup;
    }
    if (_titleMatches(normalized, const [
      'code',
      'program',
      'develop',
      'software',
    ])) {
      return Iconsax.code;
    }
    if (_titleMatches(normalized, const [
      'work',
      'office',
      'job',
      'career',
      'meeting',
    ])) {
      return Iconsax.briefcase;
    }
    if (_titleMatches(normalized, const [
      'money',
      'save',
      'budget',
      'finance',
    ])) {
      return Iconsax.wallet;
    }
    if (_titleMatches(normalized, const [
      'music',
      'guitar',
      'piano',
      'practice',
    ])) {
      return Iconsax.music;
    }
    if (_titleMatches(normalized, const ['health', 'wellness', 'wellbeing'])) {
      return Iconsax.health;
    }
    return Iconsax.flag;
  }

  /// Iconsax icon inferred from today's task [title] (same rules as [goalIconForTitle]).
  static IconData homeTodayTaskIconForTitle(String title) {
    return goalIconForTitle(title);
  }

  static bool _titleMatches(String normalized, List<String> keywords) {
    for (final keyword in keywords) {
      if (normalized.contains(keyword)) return true;
    }
    return false;
  }

  /// Accent color for active goal task difficulty labels.
  static Color taskLevelColor(String level) {
    switch (level.toUpperCase()) {
      case 'HARD':
        return const Color(0xFFDD6237);
      case 'EASY':
        return const Color(0xFF3BEEB2);
      case 'MEDIUM':
        return const Color(0xFFFA75A8);
      default:
        return const Color(0xFFA5A5A5);
    }
  }

  static DateTime weekSundayStart(DateTime day) {
    return day.subtract(Duration(days: day.weekday % 7));
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String dayLabelFor(DateTime date) {
    return AppFormatter.dayNameShort(date.weekday)[0];
  }

  static HomeDailyCalendarActivityLevel activityFromProgress(double progress) {
    final value = progress.clamp(0.0, 1.0);
    if (value >= successThreshold) {
      return HomeDailyCalendarActivityLevel.success;
    }
    if (value >= warningThreshold) {
      return HomeDailyCalendarActivityLevel.warning;
    }
    if (value > 0) return HomeDailyCalendarActivityLevel.error;
    return HomeDailyCalendarActivityLevel.none;
  }

  static Color activityColor(HomeDailyCalendarActivityLevel level) {
    final Color base;
    switch (level) {
      case HomeDailyCalendarActivityLevel.success:
        base = AppColors.success;
      case HomeDailyCalendarActivityLevel.warning:
        base = AppColors.warning;
      case HomeDailyCalendarActivityLevel.error:
        base = AppColors.error;
      case HomeDailyCalendarActivityLevel.none:
        return AppColors.grey;
    }
    return Color.lerp(base, AppColors.white, 0.18)!;
  }

  static Color activityColorForProgress(double progress) {
    return activityColor(activityFromProgress(progress));
  }

  /// Heatmap cell fill from empty ([level] 0) through [AppColors.success].
  static Color successHeatmapColor(
    BuildContext context, {
    required int level,
    int maxLevel = 4,
  }) {
    return scaledSemanticFillColor(
      context,
      base: AppColors.success,
      level: level,
      maxLevel: maxLevel,
    );
  }

  /// Thin outline for empty heatmap cells on section cards.
  static Color successHeatmapEmptyBorderColor(BuildContext context) {
    return context.onSectionCardColor.withValues(
      alpha: context.isDarkMode ? 0.42 : 0.28,
    );
  }

  /// Theme-aware ramp from section card → semantic base (heatmap, etc.).
  static Color scaledSemanticFillColor(
    BuildContext context, {
    required Color base,
    required int level,
    int maxLevel = 4,
  }) {
    final cap = maxLevel.clamp(1, 10);
    final clamped = level.clamp(0, cap);
    if (clamped == 0) {
      return context.sectionCardColor;
    }
    final t = clamped / cap;
    final contrastAnchor = context.isDarkMode
        ? AppColors.white
        : AppColors.black;
    final contrastAdjusted = Color.lerp(
      base,
      contrastAnchor,
      context.isDarkMode ? 0.2 : 0.1,
    )!;
    final mappedT = 0.3 + (t * 0.7);
    return Color.lerp(context.sectionCardColor, contrastAdjusted, mappedT)!;
  }

  static double averageProgress(Iterable<double> values) {
    final list = values.toList(growable: false);
    if (list.isEmpty) return 0;
    var sum = 0.0;
    for (final v in list) {
      sum += v.clamp(0.0, 1.0);
    }
    return (sum / list.length).clamp(0.0, 1.0);
  }
}

/// Extension on [String?] for null/empty checks. Use for readability at call sites.
extension StringHelperExtension on String? {
  /// True if this string is null or empty/whitespace-only.
  bool get isNullOrEmpty => AppHelper.isNullOrEmpty(this);

  /// True if this string is not null and has non-whitespace content.
  bool get isNotNullOrEmpty => AppHelper.isNotNullOrEmpty(this);
}
