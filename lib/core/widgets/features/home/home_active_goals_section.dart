import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/features/home/home_goal_item.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class HomeActiveGoalsSection extends GetView<HomeController> {
  const HomeActiveGoalsSection({super.key, this.onGoalTap});

  final ValueChanged<String>? onGoalTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset(
              AppImages.streak,
              width: AppResponsive.iconSize(context, factor: 0.8),
              height: AppResponsive.iconSize(context, factor: 0.8),
            ),
            AppSpacing.horizontal(context, 0.01),
            Text(
              'ACTIVE GOALS',
              style: AppTextStyles.bodyText(context).copyWith(
                color: isDark ? AppColors.white : AppColors.black,
                fontWeight: FontWeight.w600,
                fontSize: AppResponsive.scaleSize(context, 10),
              ),
            ),
          ],
        ),
        AppSpacing.vertical(context, 0.01),
        Container(
          width: double.infinity,
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkGrey : AppColors.grey,
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, factor: 5),
            ),
          ),
          child: Obx(() {
            if (controller.isLoading.value && controller.goalCards.isEmpty) {
              return Center(
                child: Lottie.asset(
                  AppLotties.loadingWhite,
                  width: AppResponsive.scaleSize(context, 52),
                  height: AppResponsive.scaleSize(context, 52),
                  fit: BoxFit.contain,
                ),
              );
            }
            if (controller.goalCards.isEmpty) {
              return Text(
                'No active goals yet',
                style: AppTextStyles.labelText(context).copyWith(
                  color: isDark ? AppColors.lightGrey : AppColors.grey,
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
                  onTap: onGoalTap == null
                      ? null
                      : () => onGoalTap!(card.goalId),
                );
              }),
            );
          }),
        ),
      ],
    );
  }
}
