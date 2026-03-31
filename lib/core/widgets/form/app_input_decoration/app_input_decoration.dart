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
    final radius = AppResponsive.radius(context, factor: 5);
    return InputDecoration(
      hintText: hintText,
      hintStyle: AppTextStyles.hintText(
        context,
      ).copyWith(color: AppColors.darkGrey),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              size: AppResponsive.iconSize(context),
              color: AppColors.black,
            )
          : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      contentPadding: AppSpacing.symmetric(context, h: 0.04, v: 0.01),
    );
  }
}
