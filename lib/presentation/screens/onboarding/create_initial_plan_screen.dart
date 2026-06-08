import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/buttons/app_icon_button.dart';
import 'package:today/core/widgets/buttons/app_text_button.dart';
import 'package:today/core/widgets/features/onboarding/initial_plan_goal_snippets.dart';
import 'package:today/core/widgets/features/planner/planner_chat_message_list.dart';
import 'package:today/core/widgets/features/onboarding/initial_plan_header.dart';
import 'package:today/core/widgets/form/app_text_field/app_text_field.dart';
import 'package:today/presentation/controllers/onboarding/create_initial_plan_controller.dart';

class CreateInitialPlanScreen extends GetView<CreateInitialPlanController> {
  const CreateInitialPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.updateKeyboardInset(MediaQuery.viewInsetsOf(context).bottom);

    return Scaffold(
      backgroundColor: context.surfaceColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: AppButton(
                  label: AppTexts.initialPlanSkipCta,
                  size: AppButtonSize.small,
                  onPressed: controller.skipForNow,
                ),
              ),
              Expanded(
                child: Obx(
                  () => ListView(
                    controller: controller.chatScrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      const InitialPlanHeader(),
                      AppSpacing.vertical(context, 0.01),
                      PlannerChatMessageList(
                        items: controller.chatMessageItems,
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                if (!controller.showSnippets) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppSpacing.vertical(context, 0.015),
                    const InitialPlanGoalSnippets(),
                  ],
                );
              }),
              AppSpacing.vertical(context, 0.015),
              Obx(() {
                final isSubmitting = controller.isSubmitting.value;
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: controller.keyboardInset.value,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AppTextField(
                              controller: controller.goalController,
                              hint: AppTexts.initialPlanCustomGoalHint,
                              maxLines: 1,
                              readOnly: isSubmitting,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.send,
                              onSubmitted: isSubmitting
                                  ? null
                                  : (_) => controller.onSendCustomGoal(),
                            ),
                          ),
                          AppSpacing.horizontal(context, 0.02),
                          AppIconButton(
                            color: context.accentPalette.buttonFilledForeground,
                            backgroundColor: context.accentPalette.buttonFilled,
                            icon: Iconsax.send_1,
                            onPressed: isSubmitting
                                ? null
                                : controller.onSendCustomGoal,
                          ),
                        ],
                      ),
                      if (!controller.keyboardVisible) ...[
                        AppSpacing.vertical(context, 0.012),
                        Center(
                          child: AppTextButton(
                            label: AppTexts.initialPlanAlreadyHaveAccount,
                            onPressed: controller.openExistingAccountLogin,
                            useAccentPalette: false,
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
