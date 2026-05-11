import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Configures system UI overlay (status bar, navigation bar, etc.).
abstract final class AppSystemUi {
  static SystemUiOverlayStyle overlayFor(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: isDark
          ? const Color(0xFF000000)
          : const Color(0xFFFFFFFF),
      systemNavigationBarIconBrightness: isDark
          ? Brightness.light
          : Brightness.dark,
    );
  }

  /// Applies overlay for the current platform brightness (e.g. before first frame).
  static void setOverlayForPlatformBrightness() {
    final dispatcher = WidgetsBinding.instance.platformDispatcher;
    final brightness = dispatcher.platformBrightness;
    SystemChrome.setSystemUIOverlayStyle(overlayFor(brightness));
  }
}
