import 'package:flutter/material.dart';

import 'package:today/core/widgets/buttons/app_dropdown_button.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class HomeGoalEntryCard extends StatelessWidget {
  const HomeGoalEntryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppResponsive.screenHeight(context) * 0.52,
      width: double.infinity,
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 5),
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter a goal you want to achieve ...',
                style: AppTextStyles.bodyText(context).copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: AppResponsive.scaleSize(context, 22),
                ),
              ),
              AppSpacing.vertical(context, 0.02),
              Row(
                children: [
                  AppDropDownButton(
                    label: 'GOAL DURATION',
                    items: const ['7 Days', '14 Days', '30 Days', '60 Days'],
                    onChanged: (_) {},
                  ),
                  AppDropDownButton(
                    label: 'RESET TIME',
                    items: const ['Daily', 'Weekly', 'Monthly'],
                    onChanged: (_) {},
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: AppResponsive.scaleSize(context, 44),
              height: AppResponsive.scaleSize(context, 44),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
