import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/common/app_progress_ring.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class HomeDailyPlanCard extends GetView<HomeController> {
  const HomeDailyPlanCard({super.key});

  @override
  Widget build(BuildContext context) {
    final onCard = context.onSectionCardColor;
    final ringSize = AppResponsive.scaleSize(context, 72);
    final trackColor = context.sectionCardRingTrackColor;
    final progressColor = AppColors.white;

    return AppSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(
                () => AppProgressRing(
                  progress: controller.dailyPlanProgress,
                  size: ringSize,
                  strokeWidth: AppResponsive.scaleSize(context, 5),
                  trackColor: trackColor,
                  progressColor: progressColor,
                  animationFactor: controller.calendarRingAnimationFactor.value,
                  centerValue:
                      '${(controller.dailyPlanProgress * 100).round()}%',
                  centerValueStyle: AppTextStyles.labelText(context).copyWith(
                    color: onCard,
                    fontWeight: FontWeight.w700,
                    fontSize: AppResponsive.scaleSize(context, 14),
                    height: 1,
                  ),
                ),
              ),
              AppSpacing.horizontal(context, 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppTexts.homeDailyPlanNotSetTitle,
                      style: AppTextStyles.labelText(context).copyWith(
                        color: onCard,
                        fontWeight: FontWeight.w600,
                        fontSize: AppResponsive.scaleSize(context, 18),
                        height: 1.3,
                      ),
                    ),
                    AppSpacing.vertical(context, 0.01),
                    AppButton(
                      label: AppTexts.homeAddGoal,
                      onPressed: controller.openAddGoalSheet,
                      size: AppButtonSize.small,
                      colors: AppButtonColors(
                        filledBackground: AppColors.success,
                        filledForeground: AppColors.white,
                        outlinedBackground: Colors.transparent,
                        outlinedForeground: AppColors.white,
                        outlinedBorder: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
