import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/features/planner/planner_chat_composer.dart';
import 'package:today/core/widgets/features/planner/planner_chat_transcript.dart';
import 'package:today/presentation/controllers/planner/calendar_chat_controller.dart';

/// Chat column with keyboard-aware composer and scrollable transcript.
class PlannerChatScreenBody<C extends CalendarChatController>
    extends GetView<C> {
  const PlannerChatScreenBody({super.key, this.header});

  final Widget? header;

  @override
  Widget build(BuildContext context) {
    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    controller.updateKeyboardInset(keyboardInset);

    return Column(
      children: [
        if (header != null) ...[header!, AppSpacing.vertical(context, 0.01)],
        Expanded(
          child: PlannerChatTranscript<C>(
            scrollController: controller.chatScrollController,
          ),
        ),
        AppSpacing.vertical(context, 0.01),
        PlannerChatComposer<C>(padding: EdgeInsets.only(bottom: keyboardInset)),
      ],
    );
  }
}
