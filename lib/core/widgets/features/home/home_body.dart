import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/widgets/common/app_page_scaffold.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/features/home/active_goals/home_active_goals_section.dart';
import 'package:today/core/widgets/features/home/calendar/home_daily_calendar_section.dart';
import 'package:today/core/widgets/features/home/goal_entry/home_goal_entry_card.dart';
import 'package:today/core/widgets/features/home/header/home_top_header.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class HomeBody extends GetView<HomeController> {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppPageScaffold.defaultBodyPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeTopHeader(),
          AppSpacing.vertical(context, 0.02),
          Obx(
            () => HomeDailyCalendarSection(
              days: controller.calendarDays.toList(),
              ringAnimationFactor: controller.calendarRingAnimationFactor.value,
              onDayTap: controller.onCalendarDayTap,
            ),
          ),
          AppSpacing.vertical(context, 0.018),
          const HomeGoalEntryCard(),
          AppSpacing.vertical(context, 0.018),
          const HomeActiveGoalsSection(),
          AppSpacing.vertical(context, 0.1),
        ],
      ),
    );
  }
}
