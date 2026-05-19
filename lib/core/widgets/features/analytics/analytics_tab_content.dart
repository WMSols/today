import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';
import 'package:today/core/widgets/features/home/calendar/home_daily_calendar_display_mode.dart';
import 'package:today/core/widgets/features/home/calendar/home_daily_calendar_section.dart';
import 'package:today/presentation/controllers/analytics/analytics_controller.dart';

class AnalyticsTabContent extends GetView<AnalyticsController> {
  const AnalyticsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppCustomAppBar.titleOnly(title: AppTexts.analyticsTitle),
          AppSpacing.vertical(context, 0.02),
          Obx(
            () => HomeDailyCalendarSection(
              days: controller.calendarDays.toList(),
              ringAnimationFactor: controller.calendarRingAnimationFactor.value,
              displayMode: HomeDailyCalendarDisplayMode.statusIcon,
            ),
          ),
        ],
      ),
    );
  }
}
