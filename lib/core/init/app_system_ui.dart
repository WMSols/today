import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Configures system UI overlay (status bar, navigation bar, etc.).
abstract class AppSystemUi {
  /// Applies the default overlay style (transparent status bar, dark icons).
  static void setOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }
}
