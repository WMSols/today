import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/buttons/app_icon_button.dart';
import 'package:today/core/widgets/form/app_text_field/app_text_field.dart';
import 'package:today/presentation/controllers/planner/calendar_chat_controller.dart';

class PlannerChatComposer<C extends CalendarChatController> extends GetView<C> {
  const PlannerChatComposer({super.key, this.padding});

  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final sendSize = AppResponsive.scaleSize(context, 44);

    final content = Obx(
      () => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: AppTextField(
              controller: controller.messageInputController,
              hint: controller.chatInputHint,
              minLines: 1,
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              onSubmitted: (_) => controller.onSendChatMessage(),
            ),
          ),
          AppSpacing.horizontal(context, 0.02),
          SizedBox(
            height: sendSize,
            child: Center(
              child: AppIconButton(
                color: context.accentPalette.buttonFilledForeground,
                backgroundColor: context.accentPalette.buttonFilled,
                icon: Iconsax.send_1,
                onPressed: controller.isChatSending.value
                    ? null
                    : controller.onSendChatMessage,
              ),
            ),
          ),
        ],
      ),
    );

    if (padding == null) return content;
    return Padding(padding: padding!, child: content);
  }
}
