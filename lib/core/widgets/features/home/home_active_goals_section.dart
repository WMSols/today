import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/core/widgets/feedback/app_loading_indicator.dart';
import 'package:today/core/widgets/features/home/home_goal_item.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class HomeActiveGoalsSection extends GetView<HomeController> {
  const HomeActiveGoalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              AppImages.goals,
              width: AppResponsive.iconSize(context, factor: 0.8),
              height: AppResponsive.iconSize(context, factor: 0.8),
            ),
            AppSpacing.horizontal(context, 0.01),
            Text(
              AppTexts.activeGoalsHeading,
              style: AppTextStyles.bodyText(context).copyWith(
                color: context.onSurfaceColor,
                fontWeight: FontWeight.w600,
                fontSize: AppResponsive.scaleSize(context, 10),
              ),
            ),
          ],
        ),
        AppSpacing.vertical(context, 0.01),
        AppSectionCard(
          paddingVertical: 0.02,
          child: Obx(() {
            if (controller.isGoalCardsLoading.value &&
                controller.goalCards.isEmpty) {
              return const Center(child: AppLoadingIndicator());
            }
            if (controller.goalCards.isEmpty) {
              return Text(
                AppTexts.noActiveGoalsYet,
                style: AppTextStyles.labelText(context).copyWith(
                  color: context.mutedOnSurfaceColor,
                  fontWeight: FontWeight.w600,
                  fontSize: AppResponsive.scaleSize(context, 11),
                ),
              );
            }
            return Column(
              children: List.generate(controller.goalCards.length, (index) {
                final card = controller.goalCards[index];
                return HomeGoalItem(
                  title: card.title,
                  subtitle: card.dayText,
                  onTap: () => controller.openActiveGoalDetails(card.goalId),
                );
              }),
            );
          }),
        ),
      ],
    );
  }
}
