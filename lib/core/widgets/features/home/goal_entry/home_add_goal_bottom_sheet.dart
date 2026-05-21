import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_dropdown_button.dart';
import 'package:today/core/widgets/features/home/goal_entry/home_goal_entry_button.dart';
import 'package:today/core/widgets/features/home/goal_entry/home_goal_entry_text_field.dart';
import 'package:today/presentation/controllers/home/home_controller.dart';

/// Add-goal form for [AppBottomSheet]; height grows with multiline input.
class HomeAddGoalBottomSheet extends GetView<HomeController> {
  const HomeAddGoalBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
            HomeGoalEntryButton(onTap: controller.submitGoalDraftAndCloseSheet),
          ],
        ),
      ],
    );
  }
}
