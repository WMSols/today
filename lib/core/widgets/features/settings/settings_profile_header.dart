import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class SettingsProfileHeader extends StatelessWidget {
  const SettingsProfileHeader({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Center(
          child: Image.asset(
            AppImages.userAvatar,
            width: AppResponsive.scaleSize(context, 100),
            height: AppResponsive.scaleSize(context, 100),
          ),
        ),
        AppSpacing.vertical(context, 0.015),
        Text(
          username,
          style: AppTextStyles.heading(context).copyWith(
            color: isDark ? AppColors.white : AppColors.black,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 16),
          ),
        ),
      ],
    );
  }
}
