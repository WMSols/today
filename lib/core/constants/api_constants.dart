/// API base URL and path segments. Base URL loaded from env in [EnvConfig].
class ApiConstants {
  ApiConstants._();

  /// Set to `true` when the new backend is ready to re-enable Dio calls.
  static const bool backendApiEnabled = false;

  static const int connectTimeoutMs = 100000;
  static const int receiveTimeoutMs = 100000;
}
