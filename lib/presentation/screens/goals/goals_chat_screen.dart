import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_icon_button.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';
import 'package:today/core/widgets/common/app_page_scaffold.dart';
import 'package:today/core/widgets/features/goals/chat/goal_chat_history_drawer.dart';
import 'package:today/core/widgets/features/planner/planner_chat_message_list.dart';
import 'package:today/core/widgets/form/app_text_field/app_text_field.dart';
import 'package:today/presentation/controllers/goals/goals_chat_controller.dart';

class GoalsChatScreen extends GetView<GoalsChatController> {
  const GoalsChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Padding(
              padding: AppPageScaffold.defaultBodyPadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(
                    () => AppCustomAppBar.titleWithActions(
                      title: controller.headerTitle,
                      onBack: Get.back<void>,
                      trailing: IconButton(
                        onPressed: controller.openDrawer,
                        icon: Icon(
                          Iconsax.menu_1,
                          color: context.onSurfaceColor,
                          size: AppResponsive.iconSize(context),
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.vertical(context, 0.01),
                  Expanded(
                    child: Obx(
                      () => SingleChildScrollView(
                        controller: controller.chatScrollController,
                        physics: const BouncingScrollPhysics(),
                        child: PlannerChatMessageList(
                          items: controller.chatMessageItems,
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.vertical(context, 0.01),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: controller.messageInputController,
                          hint: AppTexts.plannerMessageInputHint,
                          onChanged: (_) {},
                          maxLines: 1,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => controller.onSendTap(),
                        ),
                      ),
                      AppSpacing.horizontal(context, 0.02),
                      Obx(
                        () => AppIconButton(
                          color: context.accentPalette.buttonFilledForeground,
                          backgroundColor: context.accentPalette.buttonFilled,
                          icon: Iconsax.send_1,
                          onPressed: controller.isAiTyping.value
                              ? null
                              : controller.onSendTap,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const GoalChatHistoryDrawer(),
        ],
      ),
    );
  }
}
