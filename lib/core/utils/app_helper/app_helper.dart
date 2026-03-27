import 'package:flutter/material.dart';

class AppHelper {
  AppHelper._();

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
}

class AppHelpers {
  AppHelpers._();

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
}

/// Extension on [String?] for null/empty checks. Use for readability at call sites.
extension StringHelperExtension on String? {
  /// True if this string is null or empty/whitespace-only.
  bool get isNullOrEmpty => AppHelper.isNullOrEmpty(this);

  /// True if this string is not null and has non-whitespace content.
  bool get isNotNullOrEmpty => AppHelper.isNotNullOrEmpty(this);
}
