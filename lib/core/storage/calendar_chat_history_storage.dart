import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:today/core/constants/storage_keys.dart';
import 'package:today/presentation/controllers/planner/calendar_chat_session.dart';

class CalendarChatHistoryStorage {
  CalendarChatHistoryStorage(this._prefs);

  final SharedPreferences _prefs;

  List<CalendarChatSession> loadSessions() {
    final raw = _prefs.getString(StorageKeys.calendarChatSessions);
    if (raw == null || raw.isEmpty) return const [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) return const [];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(CalendarChatSession.fromJson)
          .where((session) => session.id.isNotEmpty)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  Future<void> saveSessions(List<CalendarChatSession> sessions) async {
    final encoded = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await _prefs.setString(StorageKeys.calendarChatSessions, encoded);
  }

  Future<void> clear() async {
    await _prefs.remove(StorageKeys.calendarChatSessions);
  }

  CalendarChatSession? loadCreateTaskChat() {
    final raw = _prefs.getString(StorageKeys.createTaskChat);
    if (raw == null || raw.isEmpty) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return CalendarChatSession.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveCreateTaskChat(CalendarChatSession session) async {
    await _prefs.setString(
      StorageKeys.createTaskChat,
      jsonEncode(session.toJson()),
    );
  }

  Future<void> clearCreateTaskChat() async {
    await _prefs.remove(StorageKeys.createTaskChat);
  }
}
