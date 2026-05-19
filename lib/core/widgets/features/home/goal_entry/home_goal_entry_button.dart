import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';

import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';

class HomeGoalEntryButton extends StatelessWidget {
  const HomeGoalEntryButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppResponsive.scaleSize(context, 44),
        height: AppResponsive.scaleSize(context, 44),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? AppColors.black : AppColors.white,
        ),
        child: Padding(
          padding: AppSpacing.all(context),
          child: Image.asset(
            isDark ? AppImages.appLogoWhite : AppImages.appLogoBlack,
          ),
        ),
      ),
    );
  }
}
