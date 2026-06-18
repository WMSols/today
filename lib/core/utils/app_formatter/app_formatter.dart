import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

/// Formatters: display formatting only .
/// For null/empty/parsing helpers use [AppHelper]; for validation use [AppValidator].
class AppFormatter {
  AppFormatter._();

  static const Set<String> _loadingPrepositions = {
    'in',
    'up',
    'out',
    'on',
    'off',
    'to',
    'for',
    'with',
    'from',
  };

  static const Map<String, String> _loadingVerbOverrides = {
    'log in': 'logging in',
    'sign up': 'signing up',
    'sign in': 'signing in',
    'signup': 'signing up',
    'signin': 'signing in',
    'save': 'saving',
    'create': 'creating',
    'delete': 'deleting',
    'remove': 'removing',
    'update': 'updating',
    'edit': 'editing',
    'submit': 'submitting',
    'continue': 'continuing',
    'retry': 'retrying',
    'send': 'sending',
    'sync': 'syncing',
    'generate': 'generating',
    'plan': 'planning',
  };

  /// Full date-time string: "EEE MMM dd yyyy - h:mm a" (e.g. Tue Jun 21 2005 - 10:00 PM).
  static String dateTime(DateTime timestamp) {
    final datePart = DateFormat('EEE MMM dd yyyy').format(timestamp);
    final timePart = DateFormat('h:mm a').format(timestamp);
    return '$datePart - $timePart';
  }

  /// Dashboard date label: "20 May 2026".
  static String dayMonthYear(DateTime d) {
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
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  /// Time only: "6:30 AM".
  static String timeOfDay(DateTime d) {
    return DateFormat('h:mm a').format(d);
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

  /// Time-of-day greeting label (no icon — pair with [timeOfDayGreetingImage]).
  static String timeOfDayGreeting([DateTime? when]) {
    final hour = (when ?? DateTime.now()).hour;
    if (hour >= 5 && hour < 12) return AppTexts.greetingMorning;
    if (hour >= 12 && hour < 17) return AppTexts.greetingAfternoon;
    if (hour >= 17 && hour < 21) return AppTexts.greetingEvening;
    return AppTexts.greetingNight;
  }

  /// Asset for the time-of-day greeting icon beside [timeOfDayGreeting].
  static String timeOfDayGreetingImage([DateTime? when]) {
    final hour = (when ?? DateTime.now()).hour;
    if (hour >= 5 && hour < 12) return AppImages.morning;
    if (hour >= 12 && hour < 17) return AppImages.afternoon;
    if (hour >= 17 && hour < 21) return AppImages.evening;
    return AppImages.night;
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

  /// API date `yyyy-MM-dd` in local time.
  static String apiDate(DateTime date) {
    final local = DateTime(date.year, date.month, date.day);
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '${local.year}-$month-$day';
  }

  /// API date-time without timezone suffix (local).
  static String apiDateTime(DateTime dateTime) {
    final local = dateTime.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final second = local.second.toString().padLeft(2, '0');
    return '${local.year}-$month-$day'
        'T$hour:$minute:$second';
  }

  /// Parses API date-time values from JSON.
  static DateTime? parseApiDateTime(dynamic raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    if (raw is! String || raw.trim().isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  /// Inline chat formatting: `**bold**`, `*italic*`, `~~strike~~`, `__underline__`, `` `code` ``.
  static List<InlineSpan> chatMessageSpans(String input, TextStyle style) {
    return _ChatMessageSpanParser.parse(input, style);
  }

  /// Capitalizes the first character of [text] (e.g. user chat prompts).
  static String capitalizeFirstLetter(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return trimmed;
    return trimmed[0].toUpperCase() + trimmed.substring(1);
  }

  /// Parses API `yyyy-MM-dd` (or ISO) into "13 June 2026".
  static String scheduleDisplayDate(String? rawDate) {
    final parsed = AppHelper.parseDateTimeOrNull(rawDate);
    if (parsed == null) {
      return rawDate?.trim() ?? '';
    }
    return dayMonthYear(parsed);
  }

  /// Weekday label for schedule slots (API weekday or derived from date).
  static String scheduleDisplayWeekday({String? weekday, String? apiDate}) {
    final label = weekday?.trim();
    if (label != null && label.isNotEmpty) return label;
    final parsed = AppHelper.parseDateTimeOrNull(apiDate);
    if (parsed == null) return '';
    return dayNameFull(parsed.weekday);
  }

  /// Section title for agenda screens, e.g. "Today · 15 June 2026".
  static String agendaDayHeading(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final diff = day.difference(today).inDays;
    final dateLabel = dayMonthYear(day);
    if (diff == 0) return 'Today · $dateLabel';
    if (diff == 1) return 'Tomorrow · $dateLabel';
    if (diff == -1) return 'Yesterday · $dateLabel';
    return '${dayNameFull(day.weekday)} · $dateLabel';
  }

  /// Short drawer / app-bar title from a chat message (first [maxWords] words).
  static String chatSessionTitle(String text, {int maxWords = 4}) {
    final normalized = text.trim();
    if (normalized.isEmpty) return '';
    final words = normalized
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
    if (words.isEmpty) return '';
    if (words.length <= maxWords) return words.join(' ');
    return '${words.take(maxWords).join(' ')}…';
  }

  /// Derives a progress label for button loading states.
  static String buttonLoadingLabel(String label) {
    final normalized = label.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    if (normalized.isEmpty) return AppTexts.loading;
    if (_loadingVerbOverrides.containsKey(normalized)) {
      return _sentenceCase(_loadingVerbOverrides[normalized]!);
    }

    final words = normalized.split(' ');
    final firstGerund = _toGerund(words.first);
    if (words.length == 1) return _sentenceCase(firstGerund);

    final tail = words.skip(1).toList(growable: false);
    final firstTail = tail.first;
    final restTail = tail.skip(1).join(' ');
    final phrase = _loadingPrepositions.contains(firstTail)
        ? '$firstGerund $firstTail${restTail.isEmpty ? '' : ' $restTail'}'
        : '$firstGerund ${tail.join(' ')}';
    return _sentenceCase(phrase);
  }

  static String _toGerund(String word) {
    final lower = word.toLowerCase();
    if (lower.isEmpty) return lower;
    if (_loadingVerbOverrides.containsKey(lower)) {
      return _loadingVerbOverrides[lower]!;
    }
    if (lower.endsWith('ie') && lower.length > 2) {
      return '${lower.substring(0, lower.length - 2)}ying';
    }
    if (lower.endsWith('e') &&
        !lower.endsWith('ee') &&
        !lower.endsWith('ye') &&
        lower.length > 2) {
      return '${lower.substring(0, lower.length - 1)}ing';
    }
    return '${lower}ing';
  }

  static String _sentenceCase(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}

class _ChatMessageFormatRule {
  const _ChatMessageFormatRule({required this.pattern, required this.apply});

  final RegExp pattern;
  final TextStyle Function(TextStyle style) apply;
}

class _ChatMessageSpanParser {
  _ChatMessageSpanParser._();

  static final List<_ChatMessageFormatRule> _rules = [
    _ChatMessageFormatRule(
      pattern: RegExp(r'\*\*\*(.+?)\*\*\*'),
      apply: (style) => style.copyWith(
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
      ),
    ),
    _ChatMessageFormatRule(
      pattern: RegExp(r'\*\*(.+?)\*\*'),
      apply: (style) => style.copyWith(fontWeight: FontWeight.w700),
    ),
    _ChatMessageFormatRule(
      pattern: RegExp(r'(?<!\*)\*(?!\*)(.+?)(?<!\*)\*(?!\*)'),
      apply: (style) => style.copyWith(fontStyle: FontStyle.italic),
    ),
    _ChatMessageFormatRule(
      pattern: RegExp(r'~~(.+?)~~'),
      apply: (style) => style.copyWith(decoration: TextDecoration.lineThrough),
    ),
    _ChatMessageFormatRule(
      pattern: RegExp(r'__(.+?)__'),
      apply: (style) => style.copyWith(decoration: TextDecoration.underline),
    ),
    _ChatMessageFormatRule(
      pattern: RegExp(r'`(.+?)`'),
      apply: (style) =>
          style.copyWith(fontFamily: 'monospace', fontWeight: FontWeight.w500),
    ),
  ];

  static List<InlineSpan> parse(String input, TextStyle style) {
    if (input.isEmpty) return const [];

    _ChatMessageFormatRule? matchedRule;
    RegExpMatch? match;

    for (final rule in _rules) {
      final candidate = rule.pattern.firstMatch(input);
      if (candidate == null) continue;
      if (match == null || candidate.start < match.start) {
        match = candidate;
        matchedRule = rule;
      }
    }

    if (match == null || matchedRule == null) {
      return [TextSpan(text: input, style: style)];
    }

    final before = input.substring(0, match.start);
    final inner = match.group(1) ?? '';
    final after = input.substring(match.end);

    return [
      ...parse(before, style),
      ...parse(inner, matchedRule.apply(style)),
      ...parse(after, style),
    ];
  }
}
