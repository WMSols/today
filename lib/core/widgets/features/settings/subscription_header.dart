import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';

class SubscriptionHeader extends StatelessWidget {
  const SubscriptionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppCustomAppBar.unlockProChip(onTapUnlockPro: () {}),
        AppSpacing.vertical(context, 0.04),
        Text(
          AppTexts.subscriptionTitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.heading(context).copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 28),
          ),
        ),
        AppSpacing.vertical(context, 0.01),
        Text(
          AppTexts.subscriptionSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyText(context).copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 14),
          ),
        ),
      ],
    );
  }
}
