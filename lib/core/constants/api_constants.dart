/// API base URL and path segments. Base URL loaded from env in [EnvConfig].
class ApiConstants {
  ApiConstants._();

  static const bool backendApiEnabled = true;

  static const String healthPath = '/health';
  static const String authConfigPath = '/api/auth/config';
  static const String authBootstrapPath = '/api/auth/bootstrap';

  static const String chatPath = '/api/chat';
  static const String calendarAgendaPath = '/api/calendar/agenda';
  static const String calendarEventsPath = '/api/calendar/events';

  static const int connectTimeoutMs = 100000;
  static const int receiveTimeoutMs = 100000;
}
