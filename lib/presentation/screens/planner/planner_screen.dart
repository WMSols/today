import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_drawer/app_chat_history_drawer.dart';
import 'package:today/core/widgets/features/planner/planner_chat_screen_body.dart';
import 'package:today/presentation/controllers/planner/planner_controller.dart';

class PlannerScreen extends GetView<PlannerController> {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.black : AppColors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: Padding(
              padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
              child: PlannerChatScreenBody<PlannerController>(
                header: Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => Text(
                          controller.headerTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: context.onSurfaceColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: controller.openDrawer,
                      icon: Icon(
                        Iconsax.menu_1,
                        color: context.onSurfaceColor,
                        size: AppResponsive.iconSize(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () => AppChatHistoryDrawer(
              isOpen: controller.isDrawerOpen.value,
              onClose: controller.closeDrawer,
              onNewChat: controller.startNewChat,
              newChatLabel: AppTexts.goalsChatNewChat,
              recentLabel: AppTexts.goalsChatRecent,
              entries: controller.drawerHistoryEntries,
            ),
          ),
        ],
      ),
    );
  }
}
