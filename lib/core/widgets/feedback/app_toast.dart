import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/theme/app_toast_colors.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

enum AppToastStatus { success, information, warning, error }

/// Full-width bottom bar with a single centered message (offline banner, toasts).
class AppToastBar extends StatelessWidget {
  const AppToastBar({super.key, required this.message, required this.style});

  final String message;
  final AppToastStyle style;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final backgroundColor = AppToastColors.background(style, brightness);
    final foregroundColor = AppToastColors.foreground(style, brightness);

    return Material(
      color: backgroundColor,
      child: SafeArea(
        top: false,
        child: Center(
          child: Padding(
            padding: AppSpacing.symmetric(context, v: 0.005, h: 0.04),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelText(context).copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.none,
                decorationColor: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Transient bottom feedback using the same bar design as [AppNoConnectionBanner].
abstract class AppToast {
  AppToast._();

  static const Duration _duration = Duration(seconds: 2);

  static AppToastStyle _styleFor(AppToastStatus status) {
    switch (status) {
      case AppToastStatus.success:
        return AppToastStyle.success;
      case AppToastStatus.information:
        return AppToastStyle.information;
      case AppToastStatus.warning:
        return AppToastStyle.warning;
      case AppToastStatus.error:
        return AppToastStyle.error;
    }
  }

  static void showSuccess(String message) {
    _show(status: AppToastStatus.success, message: message);
  }

  static void showInformation(String message) {
    _show(status: AppToastStatus.information, message: message);
  }

  static void showWarning(String message) {
    _show(status: AppToastStatus.warning, message: message);
  }

  static void showError(String message) {
    _show(status: AppToastStatus.error, message: message);
  }

  static void _show({required AppToastStatus status, required String message}) {
    final context = Get.context;
    if (context == null || message.trim().isEmpty) return;

    final style = _styleFor(status);

    Get.rawSnackbar(
      messageText: AppToastBar(message: message.trim(), style: style),
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.GROUNDED,
      backgroundColor: Colors.transparent,
      overlayBlur: 0,
      overlayColor: Colors.transparent,
      margin: EdgeInsets.zero,
      borderRadius: 0,
      padding: EdgeInsets.zero,
      duration: _duration,
    );
  }
}
