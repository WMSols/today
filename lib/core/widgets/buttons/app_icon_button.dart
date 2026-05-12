import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/presentation/controllers/feedback/haptics_controller.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size,
    this.paddingFactor,
    this.color,
    this.backgroundColor,
    this.useHapticFeedback = true,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double? size;
  final double? paddingFactor;
  final Color? color;
  final Color? backgroundColor;
  final bool useHapticFeedback;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconSize = size ?? AppResponsive.iconSize(context, factor: 1.3);
    final defaultIcon = isDark ? AppColors.white : AppColors.black;
    return Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(
        AppResponsive.radius(context, factor: 5),
      ),
      child: InkWell(
        onTap: onPressed == null
            ? null
            : () {
                if (useHapticFeedback) {
                  if (Get.isRegistered<HapticsController>()) {
                    Get.find<HapticsController>().impact();
                  }
                }
                onPressed!();
              },
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 5),
        ),
        child: Padding(
          padding: AppSpacing.all(context, factor: paddingFactor ?? 1),
          child: Icon(icon, size: iconSize, color: color ?? defaultIcon),
        ),
      ),
    );
  }
}
