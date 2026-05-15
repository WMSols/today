import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_custom_app_bar.dart';
import 'package:today/core/widgets/common/app_page_scaffold.dart';
import 'package:today/presentation/controllers/settings/notifications_controller.dart';

class NotificationsScreen extends GetView<NotificationsController> {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      padding: AppPageScaffold.defaultBodyPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppCustomAppBar.backOnly(onBack: () => Get.back<void>()),
          AppSpacing.vertical(context, 0.02),
          Text(
            AppTexts.notificationsTitle,
            style: AppTextStyles.headline(context).copyWith(
              color: context.onSurfaceColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.vertical(context, 0.02),
          Text(
            AppTexts.notificationsDescription,
            style: AppTextStyles.bodyText(
              context,
            ).copyWith(color: context.mutedOnSurfaceColor),
          ),
        ],
      ),
    );
  }
}
