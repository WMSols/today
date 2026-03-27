import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

class EmptyGoal extends StatelessWidget {
  const EmptyGoal({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppResponsive.screenHeight(context) * 0.3),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppImages.emptyGoal,
              width: AppResponsive.scaleSize(context, 67),
              height: AppResponsive.scaleSize(context, 82),
            ),
            AppSpacing.vertical(context, 0.008),
            Text(
              AppTexts.emptyGoalTitle,
              style: AppTextStyles.heading(context).copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: AppResponsive.scaleSize(context, 18),
              ),
            ),
            AppSpacing.vertical(context, 0.008),
            Text(
              AppTexts.emptyGoalSubtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelText(context).copyWith(
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
                fontSize: AppResponsive.scaleSize(context, 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
