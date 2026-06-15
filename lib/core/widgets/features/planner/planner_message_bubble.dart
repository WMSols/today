import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/features/planner/planner_chat_avatar.dart';
import 'package:today/core/widgets/features/planner/planner_chat_typing_indicator.dart';

enum PlannerMessageSender { ai, user }

class PlannerMessageBubble extends StatelessWidget {
  const PlannerMessageBubble({
    super.key,
    required this.sender,
    this.message,
    this.isTyping = false,
    this.avatarKind = PlannerChatAvatarKind.userPhoto,
    this.groupedWithPrevious = false,
    this.groupedWithNext = false,
  });

  final PlannerMessageSender sender;
  final String? message;
  final bool isTyping;
  final PlannerChatAvatarKind avatarKind;
  final bool groupedWithPrevious;
  final bool groupedWithNext;

  bool get _showAvatar => !groupedWithPrevious;

  BorderRadius _borderRadius(BuildContext context, bool isUser) {
    final radius = Radius.circular(AppResponsive.radius(context, factor: 3));
    final none = Radius.zero;

    if (isUser) {
      return BorderRadius.only(
        topLeft: radius,
        topRight: groupedWithPrevious ? none : radius,
        bottomLeft: radius,
        bottomRight: groupedWithNext
            ? none
            : (groupedWithPrevious ? radius : none),
      );
    }

    return BorderRadius.only(
      topLeft: groupedWithPrevious ? none : radius,
      topRight: radius,
      bottomLeft: groupedWithNext
          ? none
          : (groupedWithPrevious ? radius : none),
      bottomRight: radius,
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.accentPalette;
    final isUser = sender == PlannerMessageSender.user;
    final avatarSize = AppResponsive.scaleSize(context, 28);
    final avatarGap = AppSpacing.horizontalValue(context, 0.03);

    final Color bubbleBg = isUser
        ? palette.buttonFilled
        : context.sectionCardColor;
    final Color bubbleFg = isUser
        ? palette.buttonFilledForeground
        : context.onSectionCardColor;

    final messageStyle = AppTextStyles.bodyText(context).copyWith(
      color: bubbleFg,
      fontWeight: FontWeight.w600,
      fontSize: AppResponsive.scaleSize(context, 12),
    );

    final Widget bubbleChild;
    if (isTyping && !isUser) {
      bubbleChild = PlannerChatTypingIndicator(
        textColor: context.onSurfaceColor,
      );
    } else {
      bubbleChild = Text.rich(
        TextSpan(
          style: messageStyle,
          children: AppFormatter.chatMessageSpans(message ?? '', messageStyle),
        ),
      );
    }

    final Widget messageContent;
    if (isTyping && !isUser) {
      messageContent = bubbleChild;
    } else {
      messageContent = Container(
        padding: AppSpacing.symmetric(context, h: 0.04, v: 0.01),
        decoration: BoxDecoration(
          color: bubbleBg,
          borderRadius: _borderRadius(context, isUser),
        ),
        child: bubbleChild,
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: avatarSize,
          child: !isUser && _showAvatar
              ? PlannerChatAvatar(kind: avatarKind)
              : null,
        ),
        SizedBox(width: avatarGap),
        Expanded(
          child: Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: messageContent,
          ),
        ),
        SizedBox(width: avatarGap),
        SizedBox(
          width: avatarSize,
          child: isUser && _showAvatar
              ? PlannerChatAvatar(kind: avatarKind)
              : null,
        ),
      ],
    );
  }
}
