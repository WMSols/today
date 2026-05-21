import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/presentation/controllers/settings/haptics_controller.dart';
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
    this.useAccentPalette = true,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double? size;
  final double? paddingFactor;
  final Color? color;
  final Color? backgroundColor;
  final bool useHapticFeedback;

  /// When false, uses neutral on-surface icon color instead of the accent.
  final bool useAccentPalette;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = context.accentPalette;
    final iconSize = size ?? AppResponsive.iconSize(context, factor: 1.3);
    final iconColor =
        color ??
        (useAccentPalette
            ? palette.buttonFilledForeground
            : (isDark ? AppColors.white : AppColors.black));
    final bg = backgroundColor ?? Colors.transparent;

    return Material(
      color: bg,
      shape: const CircleBorder(),
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
        customBorder: const CircleBorder(),
        child: Padding(
          padding: AppSpacing.all(context, factor: paddingFactor ?? 1),
          child: Icon(icon, size: iconSize, color: iconColor),
        ),
      ),
    );
  }
}
