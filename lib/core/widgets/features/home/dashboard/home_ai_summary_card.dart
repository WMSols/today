import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class HomeAiSummaryCard extends GetView<HomeController> {
  const HomeAiSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      backgroundColor: AppColors.white,
      borderColor: AppColors.black,
      borderWidth: AppResponsive.scaleSize(context, 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                AppImages.appLogoBlack,
                width: AppResponsive.iconSize(context, factor: 2),
                height: AppResponsive.iconSize(context, factor: 2),
              ),
              const Spacer(),
              Obx(
                () => Text(
                  AppTexts.homeAiGeneratedAt(
                    controller.lastAiPlanGeneratedAtLabel,
                  ),
                  style: AppTextStyles.labelText(context).copyWith(
                    color: AppColors.grey,
                    fontSize: AppResponsive.scaleSize(context, 10),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.vertical(context, 0.01),
          Obx(() {
            final yesterdayPct = (controller.yesterdayCompletionProgress * 100)
                .round();
            return RichText(
              text: TextSpan(
                style: AppTextStyles.bodyText(context).copyWith(
                  color: AppColors.black,
                  fontSize: AppResponsive.scaleSize(context, 12),
                  height: 1.35,
                ),
                children: [
                  TextSpan(
                    text: controller.dashboardUserName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const TextSpan(text: AppTexts.homeAiSummaryLead),
                  TextSpan(
                    text: '$yesterdayPct%',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const TextSpan(text: AppTexts.homeAiSummaryMid),
                  TextSpan(
                    text: controller.aiFocusKeyword,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const TextSpan(text: AppTexts.homeAiSummaryTail),
                ],
              ),
            );
          }),
          AppSpacing.vertical(context, 0.02),
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton(
              label: AppTexts.homeViewAiPlan,
              onPressed: controller.openGoalsTab,
              useAccentPalette: false,
              size: AppButtonSize.small,
            ),
          ),
        ],
      ),
    );
  }
}
