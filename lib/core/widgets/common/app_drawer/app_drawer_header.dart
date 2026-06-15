import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/features/planner/planner_chat_avatar.dart';

/// Drawer top brand row: app logo + wordmark.
class AppDrawerHeader extends StatelessWidget {
  const AppDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const PlannerChatAvatar(kind: PlannerChatAvatarKind.brandLogo),
        AppSpacing.horizontal(context, 0.025),
        Text(
          AppTexts.appNewName,
          style: AppTextStyles.headline(context).copyWith(
            color: context.onSurfaceColor,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 18),
          ),
        ),
      ],
    );
  }
}
