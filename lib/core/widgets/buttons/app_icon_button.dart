import 'package:flutter/material.dart';

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
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double? size;
  final double? paddingFactor;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? AppResponsive.iconSize(context);
    return Material(
      color: backgroundColor ?? Colors.transparent,
      borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
        child: Padding(
          padding: AppSpacing.all(context, factor: paddingFactor ?? 1),
          child: Icon(icon, size: iconSize, color: color ?? AppColors.primary),
        ),
      ),
    );
  }
}
