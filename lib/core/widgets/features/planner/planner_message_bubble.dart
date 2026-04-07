import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_lotties/app_lotties.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/features/planner/planner_avatar.dart';

enum PlannerMessageSender { ai, user }

class PlannerMessageBubble extends StatelessWidget {
  const PlannerMessageBubble({
    super.key,
    required this.avatarPath,
    required this.sender,
    this.message,
    this.isTyping = false,
  });

  final String avatarPath;
  final PlannerMessageSender sender;
  final String? message;
  final bool isTyping;

  @override
  Widget build(BuildContext context) {
    final maxWidth = AppResponsive.screenWidth(context) * 0.78;
    final isUser = sender == PlannerMessageSender.user;
    final radius = AppResponsive.radius(context, factor: 3);
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
      bottomLeft: Radius.circular(isUser ? radius : 0),
      bottomRight: Radius.circular(isUser ? 0 : radius),
    );

    final bubble = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: AppSpacing.symmetric(context, h: 0.04, v: 0.015),
        decoration: BoxDecoration(
          color: sender == PlannerMessageSender.ai
              ? Color(0XFF1A1A1A)
              : Color(0XFFF8F7EF),
          borderRadius: borderRadius,
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
                  color: sender == PlannerMessageSender.ai
                      ? AppColors.white.withValues(alpha: 0.7)
                      : AppColors.black,
                  fontWeight: FontWeight.w600,
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
          PlannerAvatar(imagePath: avatarPath),
          AppSpacing.horizontal(context, 0.02),
          bubble,
        ] else ...[
          bubble,
          AppSpacing.horizontal(context, 0.02),
          PlannerAvatar(imagePath: avatarPath),
        ],
      ],
    );
  }
}
