import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/widgets/buttons/app_dropdown_button.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/features/home/home_goal_entry_button';
import 'package:today/core/widgets/features/home/home_goal_entry_text_field.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class HomeGoalEntryCard extends GetView<HomeController> {
  const HomeGoalEntryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeGoalEntryTextField(
            controller: controller.goalInputController,
            hintText: AppTexts.homeGoalEntryHint,
            onChanged: controller.setGoalDraft,
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
              Spacer(),
              HomeGoalEntryButton(),
            ],
          ),
        ],
      ),
    );
  }
}
