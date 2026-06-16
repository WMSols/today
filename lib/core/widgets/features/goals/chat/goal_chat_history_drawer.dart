import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_drawer/app_chat_history_drawer.dart';
import 'package:today/presentation/controllers/goals/goals_chat_controller.dart';

class GoalChatHistoryDrawer extends GetView<GoalsChatController> {
  const GoalChatHistoryDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AppChatHistoryDrawer(
        isOpen: controller.isDrawerOpen.value,
        onClose: controller.closeDrawer,
        onNewChat: controller.startNewChat,
        newChatLabel: AppTexts.goalsChatNewChat,
        recentLabel: AppTexts.goalsChatRecent,
        entries: controller.drawerHistoryEntries,
      ),
    );
  }
}
