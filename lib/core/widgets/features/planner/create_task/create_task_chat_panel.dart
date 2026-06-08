import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/features/planner/planner_chat_message_list.dart';
import 'package:today/presentation/controllers/planner/create_task_controller.dart';

/// Scrollable chat transcript for chat mode on [CreateTaskScreen].
class CreateTaskChatPanel extends GetView<CreateTaskController> {
  const CreateTaskChatPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView(
        controller: controller.chatScrollController,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          AppSpacing.vertical(context, 0.01),
          PlannerChatMessageList(items: controller.chatMessageItems),
        ],
      ),
    );
  }
}
