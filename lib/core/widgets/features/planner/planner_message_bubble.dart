import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/features/planner/planner_chat_avatar.dart';

enum PlannerMessageSender { ai, user }

class PlannerMessageBubble extends StatelessWidget {
  const PlannerMessageBubble({
    super.key,
    this.avatarPath,
    required this.sender,
    this.message,
    this.isTyping = false,
    this.avatarKind = PlannerChatAvatarKind.image,
    this.groupedWithPrevious = false,
    this.groupedWithNext = false,
  }) : assert(
         avatarKind == PlannerChatAvatarKind.brandLogo || avatarPath != null,
         'avatarPath is required for image avatars',
       );

  final String? avatarPath;
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

  Widget _avatarSlot(BuildContext context) {
    final size = AppResponsive.scaleSize(context, 28);
    final gap = AppSpacing.horizontalValue(context, 0.02);
    return SizedBox(width: size + gap);
  }

  Widget _avatar(BuildContext context) {
    if (!_showAvatar) return _avatarSlot(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PlannerChatAvatar(imagePath: avatarPath, kind: avatarKind),
        AppSpacing.horizontal(context, 0.02),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.accentPalette;
    final maxWidth = AppResponsive.screenWidth(context) * 0.78;
    final isUser = sender == PlannerMessageSender.user;

    final Color bubbleBg = isUser
        ? palette.buttonFilled
        : context.sectionCardColor;
    final Color bubbleFg = isUser
        ? palette.buttonFilledForeground
        : context.onSectionCardColor;

    final bubble = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: AppSpacing.symmetric(context, h: 0.04, v: 0.01),
        decoration: BoxDecoration(
          color: bubbleBg,
          borderRadius: _borderRadius(context, isUser),
        ),
        child: isTyping
            ? Lottie.asset(
                AppLotties.typing,
                width: AppResponsive.iconSize(context, factor: 1),
                fit: BoxFit.contain,
              )
            : Text(
                message ?? '',
                style: AppTextStyles.bodyText(context).copyWith(
                  color: bubbleFg,
                  fontWeight: FontWeight.w600,
                  fontSize: AppResponsive.scaleSize(context, 12),
                ),
              ),
      ),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: isUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        if (!isUser) ...[
          _avatar(context),
          bubble,
        ] else ...[
          bubble,
          _avatar(context),
        ],
      ],
    );
  }
}
