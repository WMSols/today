import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

class CreatingPlanScreen extends StatelessWidget {
  const CreatingPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          child: Column(
            children: [
              const Spacer(),
              Text(
                AppTexts.creatingPlanTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading(context).copyWith(
                  color: isDark ? AppColors.white : AppColors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: AppResponsive.scaleSize(context, 18),
                ),
              ),
              AppSpacing.vertical(context, 0.01),
              Lottie.asset(
                AppLotties.theoSpeech,
                width: AppResponsive.scaleSize(context, 357),
                height: AppResponsive.scaleSize(context, 357),
                fit: BoxFit.contain,
              ),
              AppSpacing.vertical(context, 0.01),
              Text(
                AppTexts.didYouKnow,
                style: AppTextStyles.labelText(context).copyWith(
                  color: isDark
                      ? AppColors.white.withValues(alpha: 0.7)
                      : AppColors.black.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                  fontSize: AppResponsive.scaleSize(context, 12),
                  letterSpacing: 0.8,
                ),
              ),
              AppSpacing.vertical(context, 0.004),
              Text(
                AppTexts.didYouKnowDescription,
                textAlign: TextAlign.center,
                style: AppTextStyles.labelText(context).copyWith(
                  color: isDark ? AppColors.white : AppColors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: AppResponsive.scaleSize(context, 18),
                  height: 1.2,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
