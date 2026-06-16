import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

/// Shared [InputDecoration] for text fields, dropdowns, and search fields.
/// Use [AppInputDecoration.decoration] with optional [hintText], [prefixIcon], [suffixIcon].
class AppInputDecoration {
  AppInputDecoration._();

  static InputDecoration decoration(
    BuildContext context, {
    String? hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.black : AppColors.white;
    final onSurface = isDark ? AppColors.white : AppColors.black;
    final borderColor = isDark ? AppColors.lightGrey : AppColors.grey;
    final radius = AppResponsive.radius(context, factor: 4);
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.hintText(
        context,
      ).copyWith(color: AppColors.grey),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              size: AppResponsive.iconSize(context, factor: 0.96),
              color: AppColors.grey,
            )
          : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: onSurface, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: AppSpacing.symmetric(context, h: 0.021, v: 0.005),
    );
  }
}
