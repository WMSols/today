import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/buttons/app_icon_button.dart';
import 'package:today/core/widgets/form/app_text_field/app_text_field.dart';
import 'package:today/presentation/controllers/planner/create_task_controller.dart';

/// Confirm CTA and message composer for chat mode on [CreateTaskScreen].
class CreateTaskChatFooter extends GetView<CreateTaskController> {
  const CreateTaskChatFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(bottom: controller.keyboardInset.value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (controller.showConfirmButton.value) ...[
              Center(
                child: SizedBox(
                  width: AppResponsive.screenWidth(context) * 0.8,
                  child: AppButton(
                    label: AppTexts.confirm,
                    primary: false,
                    onPressed: controller.onConfirmChatTap,
                  ),
                ),
              ),
              AppSpacing.vertical(context, 0.01),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: AppTextField(
                    controller: controller.messageInputController,
                    hint: AppTexts.createTaskChatInputHint,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => controller.onSendChatMessage(),
                  ),
                ),
                AppSpacing.horizontal(context, 0.02),
                AppIconButton(
                  color: context.accentPalette.buttonFilledForeground,
                  backgroundColor: context.accentPalette.buttonFilled,
                  icon: Iconsax.send_1,
                  onPressed: controller.onSendChatMessage,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
