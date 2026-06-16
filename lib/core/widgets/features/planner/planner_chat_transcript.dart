import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:iconsax/iconsax.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/features/calendar/schedule_display_section.dart';
import 'package:today/core/widgets/features/planner/planner_chat_avatar.dart';
import 'package:today/core/widgets/features/planner/planner_chat_message_list.dart';
import 'package:today/core/widgets/features/planner/planner_message_bubble.dart';
import 'package:today/presentation/controllers/planner/calendar_chat_controller.dart';

class PlannerChatTranscript<C extends CalendarChatController>
    extends StatefulWidget {
  const PlannerChatTranscript({super.key, this.scrollController, this.padding});

  final ScrollController? scrollController;
  final EdgeInsetsGeometry? padding;

  @override
  State<PlannerChatTranscript<C>> createState() =>
      _PlannerChatTranscriptState<C>();
}

class _PlannerChatTranscriptState<C extends CalendarChatController>
    extends State<PlannerChatTranscript<C>> {
  C get controller => Get.find<C>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (controller.chatMessages.isNotEmpty || controller.hasPinnedSchedule) {
        controller.scrollChatToBottom(animated: false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final children = <Widget>[
        PlannerChatMessageList(
          items: controller.chatMessageItemsBeforeSchedule,
        ),
        if (controller.hasPinnedSchedule &&
            controller.pinnedScheduleDisplay != null) ...[
          AppSpacing.vertical(context, 0.02),
          ScheduleDisplaySection(display: controller.pinnedScheduleDisplay!),
          if (controller.showViewFullAgendaButton) ...[
            AppSpacing.vertical(context, 0.02),
            AppButton(
              label: AppTexts.viewFullAgenda,
              icon: Iconsax.arrow_right_3,
              iconPosition: IconPosition.right,
              useAccentPalette: true,
              onPressed: controller.openFullAgenda,
            ),
          ],
        ],
        if (controller.chatMessageItemsAfterSchedule.isNotEmpty) ...[
          AppSpacing.vertical(context, 0.02),
          PlannerChatMessageList(
            items: controller.chatMessageItemsAfterSchedule,
          ),
        ],
        if (controller.isAiTyping.value) ...[
          AppSpacing.vertical(context, 0.01),
          const PlannerChatMessageList(
            items: [
              PlannerChatMessageItem(
                sender: PlannerMessageSender.ai,
                isTyping: true,
                avatarKind: PlannerChatAvatarKind.brandLogo,
              ),
            ],
          ),
        ],
      ];

      if (widget.scrollController != null) {
        return ListView(
          controller: widget.scrollController,
          physics: const BouncingScrollPhysics(),
          padding: widget.padding ?? EdgeInsets.zero,
          children: [
            if (widget.padding == null) AppSpacing.vertical(context, 0.01),
            ...children,
          ],
        );
      }

      return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: widget.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      );
    });
  }
}
