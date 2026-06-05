import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/features/planner/planner_chat_message_list.dart';
import 'package:today/presentation/controllers/planner/planner_controller.dart';

class PlannerChatIntro extends GetView<PlannerController> {
  const PlannerChatIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.vertical(context, 0.02),
          PlannerChatMessageList(items: controller.chatMessageItems),
          const Spacer(),
          IgnorePointer(
            child: Container(
              color: isDark
                  ? AppColors.black
                  : AppColors.white.withValues(alpha: 0),
            ),
          ),
        ],
      ),
    );
  }
}
