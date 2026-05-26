import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';
import 'package:today/core/widgets/common/app_daily_quote_section.dart';
import 'package:today/core/widgets/common/app_pull_to_refresh.dart';
import 'package:today/core/widgets/feedback/app_loading_indicator.dart';
import 'package:today/core/widgets/features/goals/empty_goal.dart';
import 'package:today/core/widgets/features/goals/goals_card_item.dart';
import 'package:today/core/widgets/features/goals/goals_stats_section.dart';
import 'package:today/presentation/controllers/goals/goals_controller.dart';

import 'package:today/core/widgets/common/app_page_scaffold.dart';

class GoalsScreen extends GetView<GoalsController> {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.ensureDailyQuoteLoaded();

    return ColoredBox(
      color: context.surfaceColor,
      child: AppPullToRefresh(
        onRefresh: controller.refreshGoals,
        child: Obx(() {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: AppPageScaffold.defaultBodyPadding(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppCustomAppBar.titleOnly(title: AppTexts.goals),
                AppSpacing.vertical(context, 0.02),
                const GoalsStatsSection(),
                AppSpacing.vertical(context, 0.025),
                if (controller.isLoading.value)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: AppLoadingIndicator()),
                  )
                else if (controller.showEmptyGoal.value ||
                    controller.goalCards.isEmpty)
                  const EmptyGoal()
                else
                  ...List.generate(controller.goalCards.length, (index) {
                    final card = controller.goalCards[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == controller.goalCards.length - 1
                            ? 0
                            : AppResponsive.scaleSize(context, 12),
                      ),
                      child: GoalsCardItem(
                        title: card.title,
                        dayText: card.dayText,
                        tasksText: card.tasksText,
                        percentText: card.percentText,
                        totalTasksText: card.totalTasksText,
                        progress: card.progress,
                        onTap: controller.openEmptyGoal,
                      ),
                    );
                  }),
                AppSpacing.vertical(context, 0.04),
                Center(
                  child: Obx(() {
                    final quote = controller.dailyQuote.value;
                    if (controller.isDailyQuoteLoading.value || quote == null) {
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
                AppSpacing.vertical(context, 0.1),
              ],
            ),
          );
        }),
      ),
    );
  }
}
