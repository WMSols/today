import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';

class SocialActionButton extends StatelessWidget {
  const SocialActionButton({
    super.key,
    required this.image,
    required this.onTap,
  });

  final String image;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tint = isDark ? AppColors.lightGrey : AppColors.darkGrey;
    return Material(
      color: tint,
      borderRadius: BorderRadius.circular(
        AppResponsive.radius(context, factor: 4),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 4),
        ),
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.021, v: 0.008),
          child: Image.asset(
            image,
            width: AppResponsive.iconSize(context, factor: 0.96),
            height: AppResponsive.iconSize(context, factor: 0.96),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
