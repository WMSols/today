import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/features/planner/planner_message_bubble.dart';

class PlannerChatIntro extends StatelessWidget {
  const PlannerChatIntro({super.key});

  static const String welcomeMessage =
      'Heyy 👋 and welcome to your daily task planner - Today';
  static const String namePrompt = 'What would you like to be called?';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.vertical(context, 0.02),
        const PlannerMessageBubble(
          avatarPath: AppImages.aiAvatar,
          sender: PlannerMessageSender.ai,
          message: welcomeMessage,
        ),
        AppSpacing.vertical(context, 0.02),
        const PlannerMessageBubble(
          avatarPath: AppImages.aiAvatar,
          sender: PlannerMessageSender.ai,
          message: namePrompt,
        ),
        AppSpacing.vertical(context, 0.03),
        const PlannerMessageBubble(
          avatarPath: AppImages.userAvatar,
          sender: PlannerMessageSender.user,
          isTyping: true,
        ),
        const Spacer(),
        IgnorePointer(
          child: Container(color: AppColors.black.withValues(alpha: 0)),
        ),
      ],
    );
  }
}

