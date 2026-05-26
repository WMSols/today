import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';
import 'package:today/core/widgets/common/app_daily_quote_section.dart';
import 'package:today/core/widgets/common/app_page_scaffold.dart';
import 'package:today/core/widgets/feedback/app_loading_indicator.dart';
import 'package:today/core/widgets/features/home/todays_tasks/home_today_tasks_timeline.dart';
import 'package:today/core/widgets/features/home/todays_tasks/todays_tasks_stats_section.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class TodaysTasksScreen extends GetView<HomeController> {
  const TodaysTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.ensureCalendarQuoteLoaded();

    return Scaffold(
      backgroundColor: context.surfaceColor,
      body: SafeArea(
        child: Padding(
          padding: AppPageScaffold.defaultBodyPadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCustomAppBar.titleWithActions(
                title: AppTexts.todaysTasksHeading,
                onBack: Get.back<void>,
              ),
              AppSpacing.vertical(context, 0.02),
              const TodaysTasksStatsSection(),
              AppSpacing.vertical(context, 0.025),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Obx(
                    () => HomeTodayTasksTimeline(
                      tasks: controller.todayTasks.toList(),
                      selectedTaskId: controller.selectedTodayTaskId.value,
                      onTaskTap: controller.selectTodayTask,
                      onTaskDone: controller.completeTodayTask,
                      onTaskSkip: controller.skipTodayTask,
                    ),
                  ),
                ),
              ),
              AppSpacing.vertical(context, 0.02),
              Center(
                child: Obx(() {
                  final quote = controller.calendarQuote.value;
                  if (controller.isCalendarQuoteLoading.value ||
                      quote == null) {
                    return AppLoadingIndicator(
                      width: AppResponsive.screenWidth(context) * 0.8,
                      height: AppResponsive.scaleSize(context, 48),
                    );
                  }
                  return AppDailyQuoteSection(
                    quote: quote.quote,
                    author: quote.author,
                  );
                }),
              ),
              AppSpacing.vertical(context, 0.01),
            ],
          ),
        ),
      ),
    );
  }
}
