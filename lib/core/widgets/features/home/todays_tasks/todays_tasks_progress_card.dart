import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_progress_ring.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class TodaysTasksProgressCard extends GetView<HomeController> {
  const TodaysTasksProgressCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final totalTasks = controller.todayTasksTotalCount;
      final progress = controller.todayProgressCardRatio;
      final statusColor = totalTasks > 0
          ? AppHelper.activityColorForProgress(progress)
          : AppHelper.activityColor(HomeDailyCalendarActivityLevel.none);
      final onCard = context.onSectionCardColor;
      final trackColor = context.sectionCardRingTrackColor;
      final percentLabel = '${(progress * 100).round()}%';

      return SizedBox.expand(
        child: AppSectionCard(
          paddingHorizontal: 0.03,
          paddingVertical: 0.02,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSectionCardHeader(
                icon: Iconsax.chart_2,
                title: AppTexts.todaysTasksProgressLabel,
                iconColor: onCard,
                iconSizeFactor: 0.6,
                titleFontSize: 9,
              ),
              const Spacer(),
              Text(
                percentLabel,
                style: AppTextStyles.heading(context).copyWith(
                  color: onCard,
                  fontWeight: FontWeight.w700,
                  fontSize: AppResponsive.scaleSize(context, 28),
                  height: 1,
                ),
              ),
              AppSpacing.vertical(context, 0.01),
              AppLinearProgressBar(
                progress: progress,
                trackColor: trackColor,
                progressColor: statusColor,
                animationFactor:
                    controller.todayProgressRingAnimationFactor.value,
                height: AppResponsive.scaleSize(context, 8),
              ),
            ],
          ),
        ),
      );
    });
  }
}
