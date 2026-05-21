import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:today/core/extensions/theme_context_extension.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_icon_button.dart';
import 'package:today/core/widgets/common/app_progress_ring.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class HomeProgressCard extends GetView<HomeController> {
  const HomeProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final totalTasks = controller.todayTasksTotalCount;
      final progress = controller.todayProgressCardRatio;
      final statusColor = totalTasks > 0
          ? AppHelper.activityColorForProgress(progress)
          : AppHelper.activityColor(HomeDailyCalendarActivityLevel.none);
      final ringSize = AppResponsive.scaleSize(context, 88);
      final trackColor = AppColors.white.withValues(alpha: 0.25);
      final progressColor = AppColors.white;
      final percentLabel = '${(progress * 100).round()}%';
      final tasksFraction = controller.todayProgressCardTasksFraction;
      final dateLabel = AppFormatter.dayMonthYear(DateTime.now());

      return AppSectionCard(
        backgroundColor: statusColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppIconButton(
                        icon: Iconsax.arrow_right_3,
                        color: AppColors.white,
                        backgroundColor: context.sectionCardColor,
                        size: AppResponsive.iconSize(context, factor: 0.6),
                        onPressed: controller.openStatsTab,
                      ),
                      AppSpacing.horizontal(context, 0.02),
                      Text(
                        AppTexts.homeYourProgress,
                        style: AppTextStyles.labelText(context).copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: AppResponsive.scaleSize(context, 12),
                        ),
                      ),
                    ],
                  ),
                  AppSpacing.vertical(context, 0.01),
                  Text(
                    percentLabel,
                    style: AppTextStyles.heading(context).copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: AppResponsive.scaleSize(context, 36),
                      height: 1,
                    ),
                  ),
                  AppSpacing.vertical(context, 0.005),
                  Text(
                    dateLabel,
                    style: AppTextStyles.labelText(context).copyWith(
                      color: AppColors.white.withValues(alpha: 0.92),
                      fontSize: AppResponsive.scaleSize(context, 11),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            AppProgressRing(
              progress: progress,
              size: ringSize,
              strokeWidth: AppResponsive.scaleSize(context, 6),
              trackColor: trackColor,
              progressColor: progressColor,
              animationFactor:
                  controller.todayProgressRingAnimationFactor.value,
              style: AppProgressRingStyle.simple,
              centerValue: tasksFraction,
              centerSubLabel: AppTexts.homeTasksRingLabel,
              centerValueStyle: AppTextStyles.labelText(context).copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: AppResponsive.scaleSize(context, 20),
                height: 1,
              ),
              centerSubLabelStyle: AppTextStyles.labelText(context).copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
                fontSize: AppResponsive.scaleSize(context, 8),
                letterSpacing: 0.8,
                height: 1,
              ),
            ),
          ],
        ),
      );
    });
  }
}
