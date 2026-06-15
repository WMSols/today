import 'package:flutter/material.dart';

import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/features/planner/planner_chat_avatar.dart';
import 'package:today/core/widgets/features/planner/planner_message_bubble.dart';

class PlannerChatMessageItem {
  const PlannerChatMessageItem({
    required this.sender,
    this.message,
    this.isTyping = false,
    this.avatarKind = PlannerChatAvatarKind.userPhoto,
  });

  final PlannerMessageSender sender;
  final String? message;
  final bool isTyping;
  final PlannerChatAvatarKind avatarKind;
}

/// Renders [items] with grouped consecutive bubbles (shared sender).
class PlannerChatMessageList extends StatelessWidget {
  const PlannerChatMessageList({
    super.key,
    required this.items,
    this.leading,
    this.trailing,
    this.groupedSpacingFactor = 0.006,
    this.separatedSpacingFactor = 0.02,
  });

  final List<PlannerChatMessageItem> items;
  final Widget? leading;
  final Widget? trailing;
  final double groupedSpacingFactor;
  final double separatedSpacingFactor;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [?leading, ?trailing],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ?leading,
        ...List.generate(items.length, (index) {
          final item = items[index];
          final previous = index > 0 ? items[index - 1] : null;
          final next = index < items.length - 1 ? items[index + 1] : null;
          final groupedWithPrevious =
              previous != null && previous.sender == item.sender;
          final groupedWithNext = next != null && next.sender == item.sender;
          final spacingFactor = groupedWithNext
              ? groupedSpacingFactor
              : separatedSpacingFactor;

          return Padding(
            padding: EdgeInsets.only(
              bottom: index == items.length - 1
                  ? 0
                  : AppSpacing.verticalValue(context, spacingFactor),
            ),
            child: PlannerMessageBubble(
              sender: item.sender,
              message: item.message,
              isTyping: item.isTyping,
              avatarKind: item.avatarKind,
              groupedWithPrevious: groupedWithPrevious,
              groupedWithNext: groupedWithNext,
            ),
          );
        }),
        ?trailing,
      ],
    );
  }
}
