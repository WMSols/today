import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/common/app_count_badge.dart';

class SettingsProfileHeader extends StatelessWidget {
  const SettingsProfileHeader({super.key, required this.onTapClaimRewards});

  final VoidCallback onTapClaimRewards;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTapClaimRewards,
          child: Center(
            child: Image.asset(
              AppImages.userAvatar,
              width: AppResponsive.scaleSize(context, 100),
              height: AppResponsive.scaleSize(context, 100),
            ),
          ),
        ),
        AppSpacing.vertical(context, 0.015),
        Text(
          'MARISOL ORTEGA',
          style: AppTextStyles.heading(context).copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 16),
          ),
        ),
        AppSpacing.vertical(context, 0.012),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppCountBadge(iconPath: AppImages.gem, count: '8'),
            AppSpacing.horizontal(context, 0.02),
            AppCountBadge(iconPath: AppImages.streak, count: '8'),
          ],
        ),
      ],
    );
  }
}
