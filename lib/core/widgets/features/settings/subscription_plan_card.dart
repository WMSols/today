import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/domain/entities/subscription_plan_entity.dart';

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  final SubscriptionPlanEntity plan;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryFill = isDark ? AppColors.secondary : AppColors.primary;
    final onPrimary = isDark ? AppColors.primary : AppColors.secondary;
    final cardBg = isDark ? AppColors.darkGrey : AppColors.grey;
    final normalFg = isDark ? AppColors.white : AppColors.black;
    final borderColor = isSelected
        ? primaryFill
        : (isDark ? AppColors.lightGrey : AppColors.grey);

    final bgColor = isSelected ? primaryFill : cardBg;
    final titleColor = isSelected ? onPrimary : normalFg;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        width: double.infinity,
        padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(
            AppResponsive.radius(context, factor: 3),
          ),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.name,
                    style: AppTextStyles.heading(context).copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                      fontSize: AppResponsive.scaleSize(context, 16),
                    ),
                  ),
                  Text(
                    plan.subtitle,
                    style: AppTextStyles.labelText(context).copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w600,
                      fontSize: AppResponsive.scaleSize(context, 10),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              plan.price,
              style: AppTextStyles.heading(context).copyWith(
                color: titleColor,
                fontWeight: FontWeight.w600,
                fontSize: AppResponsive.scaleSize(context, 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
