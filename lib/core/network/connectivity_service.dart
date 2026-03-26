import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';

/// Provides connectivity status and guards for critical actions that require internet.
class ConnectivityService extends GetxService {
  ConnectivityService() {
    _subscription = Connectivity().onConnectivityChanged.listen(
      _onConnectivityChanged,
    );
    _init();
  }

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  final RxBool isOnline = true.obs;

  Future<void> _init() async {
    final result = await Connectivity().checkConnectivity();
    _setOnline(_hasConnection(result));
  }

  void _onConnectivityChanged(List<ConnectivityResult> result) {
    _setOnline(_hasConnection(result));
  }

  bool _hasConnection(List<ConnectivityResult> result) {
    if (result.isEmpty) return false;
    return result.any((r) => r != ConnectivityResult.none);
  }

  void _setOnline(bool value) {
    if (isOnline.value != value) {
      isOnline.value = value;
    }
  }

  /// One-time check: returns true if device has connectivity (wifi/mobile/etc).
  Future<bool> get hasConnection async {
    final result = await Connectivity().checkConnectivity();
    return _hasConnection(result);
  }

  /// Call before a critical action. Returns true if online; if no connection, shows toast and returns false.
  Future<bool> guardConnection() async {
    final connected = await hasConnection;
    if (!connected) {
      AppToast.showError(AppTexts.error, AppTexts.noInternet);
    }
    return connected;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
