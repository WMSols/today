import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

enum AppToastStatus { success, information, warning, error }

class AppToast extends StatelessWidget {
  const AppToast({
    super.key,
    required this.status,
    required this.title,
    this.subtitle,
    this.icon,
  });

  final AppToastStatus status;
  final String title;
  final String? subtitle;
  final IconData? icon;

  static String _defaultTitle(AppToastStatus status) {
    switch (status) {
      case AppToastStatus.success:
        return 'Success';
      case AppToastStatus.information:
        return 'Information';
      case AppToastStatus.warning:
        return 'Warning';
      case AppToastStatus.error:
        return 'Error';
    }
  }

  static IconData _defaultIcon(AppToastStatus status) {
    switch (status) {
      case AppToastStatus.success:
        return Iconsax.tick_circle;
      case AppToastStatus.information:
        return Iconsax.info_circle;
      case AppToastStatus.warning:
        return Iconsax.warning_2;
      case AppToastStatus.error:
        return Iconsax.information;
    }
  }

  static Color _backgroundColor(AppToastStatus status) {
    switch (status) {
      case AppToastStatus.success:
        return AppColors.success;
      case AppToastStatus.information:
        return AppColors.information;
      case AppToastStatus.warning:
        return AppColors.warning;
      case AppToastStatus.error:
        return AppColors.error;
    }
  }

  /// Shows a success toast. No blur effect.
  static void showSuccess(String title, [String? subtitle]) {
    _showToast(
      status: AppToastStatus.success,
      title: title,
      subtitle: subtitle,
    );
  }

  /// Shows an information toast. No blur effect.
  static void showInformation(String title, [String? subtitle]) {
    _showToast(
      status: AppToastStatus.information,
      title: title,
      subtitle: subtitle,
    );
  }

  /// Shows a warning toast. No blur effect.
  static void showWarning(String title, [String? subtitle]) {
    _showToast(
      status: AppToastStatus.warning,
      title: title,
      subtitle: subtitle,
    );
  }

  /// Shows an error toast. No blur effect.
  static void showError(String title, [String? subtitle]) {
    _showToast(status: AppToastStatus.error, title: title, subtitle: subtitle);
  }

  static void _showToast({
    required AppToastStatus status,
    required String title,
    String? subtitle,
    IconData? icon,
  }) {
    final context = Get.context!;
    final effectiveTitle = title.isEmpty ? _defaultTitle(status) : title;
    final effectiveIcon = icon ?? _defaultIcon(status);
    final bgColor = _backgroundColor(status);

    Get.rawSnackbar(
      title: '',
      message: '',
      titleText: Text(
        effectiveTitle,
        style: AppTextStyles.bodyText(
          context,
        ).copyWith(fontWeight: FontWeight.w600, color: AppColors.white),
      ),
      messageText: subtitle != null && subtitle.isNotEmpty
          ? Text(
              subtitle,
              style: AppTextStyles.labelText(
                context,
              ).copyWith(color: AppColors.white),
            )
          : const SizedBox.shrink(),
      icon: Icon(
        effectiveIcon,
        color: AppColors.white,
        size: AppResponsive.scaleSize(context, 28),
      ),
      backgroundColor: bgColor,
      overlayBlur: 0,
      overlayColor: Colors.transparent,
      snackPosition: SnackPosition.BOTTOM,
      snackStyle: SnackStyle.FLOATING,
      margin: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
      borderRadius: AppResponsive.radius(context, factor: 1.6),
      duration: const Duration(seconds: 5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTitle = title.isEmpty ? _defaultTitle(status) : title;
    final effectiveIcon = icon ?? _defaultIcon(status);
    final bgColor = _backgroundColor(status);

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(
        AppResponsive.radius(context, factor: 1.6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            effectiveIcon,
            color: AppColors.white,
            size: AppResponsive.scaleSize(context, 28),
          ),
          AppSpacing.horizontal(context, 0.02),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  effectiveTitle,
                  style: AppTextStyles.bodyText(context).copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  Text(
                    subtitle!,
                    style: AppTextStyles.labelText(
                      context,
                    ).copyWith(color: AppColors.white),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
