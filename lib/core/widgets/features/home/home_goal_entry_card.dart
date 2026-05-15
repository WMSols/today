import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/widgets/buttons/app_dropdown_button.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/core/widgets/features/home/home_goal_entry_button.dart';
import 'package:today/core/widgets/features/home/home_goal_entry_text_field.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

class HomeGoalEntryCard extends GetView<HomeController> {
  const HomeGoalEntryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSectionCard(
      paddingVertical: 0.02,
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
                label: AppTexts.goalDurationLabel,
                items: AppTexts.goalDurationDropdownOptions,
                onChanged: (_) {},
              ),
              AppDropDownButton(
                label: AppTexts.resetTimeLabel,
                items: AppTexts.goalResetFrequencyDropdownOptions,
                onChanged: (_) {},
              ),
              const Spacer(),
              HomeGoalEntryButton(onTap: controller.createGoalFromDraft),
            ],
          ),
        ],
      ),
    );
  }
}
