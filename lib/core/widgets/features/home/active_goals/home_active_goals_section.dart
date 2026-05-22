import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/buttons/app_text_button.dart';
import 'package:today/core/widgets/feedback/app_loading_indicator.dart';
import 'package:today/core/widgets/features/home/active_goals/home_active_goal_item.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class HomeActiveGoalsSection extends GetView<HomeController> {
  const HomeActiveGoalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppTexts.activeGoalsHeading,
              style: AppTextStyles.bodyText(context).copyWith(
                color: context.onSurfaceColor,
                fontWeight: FontWeight.w600,
                fontSize: AppResponsive.scaleSize(context, 14),
              ),
            ),
            AppTextButton(
              label: AppTexts.viewAll,
              onPressed: controller.openGoalsTab,
              color: context.accentPalette.accent,
              icon: Iconsax.arrow_right_3,
              iconPosition: IconPosition.right,
            ),
          ],
        ),
        Obx(() {
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
          final cards = controller.goalCards;
          return Column(
            children: List.generate(cards.length, (index) {
              final card = cards[index];
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < cards.length - 1
                      ? AppSpacing.verticalValue(context, 0.005)
                      : 0,
                ),
                child: HomeActiveGoalItem(
                  title: card.title,
                  tasksText: card.tasksText,
                  progress: card.progress,
                  onTap: () => controller.openActiveGoalDetails(card.goalId),
                ),
              );
            }),
          );
        }),
      ],
    );
  }
}
