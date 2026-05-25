import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/widgets/common/app_page_scaffold.dart';
import 'package:today/core/widgets/common/app_pull_to_refresh.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/features/home/active_goals/home_active_goals_section.dart';
import 'package:today/core/widgets/features/home/calendar/home_daily_calendar_section.dart';
import 'package:today/core/widgets/features/home/dashboard/home_ai_summary_card.dart';
import 'package:today/core/widgets/features/home/dashboard/home_daily_plan_card.dart';
import 'package:today/core/widgets/features/home/dashboard/home_progress_card.dart';
import 'package:today/core/widgets/features/home/todays_tasks/home_todays_tasks_section.dart';
import 'package:today/core/widgets/features/home/header/home_top_header.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class HomeBody extends GetView<HomeController> {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPullToRefresh(
      onRefresh: controller.refreshHome,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        padding: AppPageScaffold.defaultBodyPadding(context).copyWith(top: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeTopHeader(),
            AppSpacing.vertical(context, 0.02),
            Obx(
              () => HomeDailyCalendarSection(
                days: controller.calendarDays.toList(),
                ringAnimationFactor:
                    controller.calendarRingAnimationFactor.value,
                onDayTap: controller.onCalendarDayTap,
              ),
            ),
            AppSpacing.vertical(context, 0.01),
            const HomeAiSummaryCard(),
            AppSpacing.vertical(context, 0.01),
            const HomeDailyPlanCard(),
            AppSpacing.vertical(context, 0.01),
            const HomeProgressCard(),
            AppSpacing.vertical(context, 0.01),
            const HomeTodaysTasksSection(),
            AppSpacing.vertical(context, 0.01),
            const HomeActiveGoalsSection(),
            AppSpacing.vertical(context, 0.1),
          ],
        ),
      ),
    );
  }
}
