import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/widgets/buttons/app_button.dart';
import 'package:today/core/widgets/common/app_drawer/app_drawer_header.dart';
import 'package:today/core/widgets/common/app_drawer/app_drawer_history_tile.dart';
import 'package:today/core/widgets/common/app_drawer/app_drawer_panel.dart';
import 'package:today/core/widgets/common/app_drawer/app_side_drawer.dart';
import 'package:today/core/widgets/form/app_form_section_text/app_form_section_text.dart';

class AppChatHistoryDrawer extends StatelessWidget {
  const AppChatHistoryDrawer({
    super.key,
    required this.isOpen,
    required this.onClose,
    required this.onNewChat,
    required this.newChatLabel,
    required this.recentLabel,
    required this.entries,
  });

  final bool isOpen;
  final VoidCallback onClose;
  final VoidCallback onNewChat;
  final String newChatLabel;
  final String recentLabel;
  final List<AppDrawerHistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    return AppSideDrawer(
      isOpen: isOpen,
      onClose: onClose,
      panel: AppDrawerPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppDrawerHeader(),
            AppSpacing.vertical(context, 0.02),
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: newChatLabel,
                icon: Iconsax.add,
                onPressed: onNewChat,
              ),
            ),
            AppSpacing.vertical(context, 0.02),
            AppFormSectionText(
              recentLabel,
              color: context.onSurfaceColor.withValues(alpha: 0.5),
            ),
            AppSpacing.vertical(context, 0.005),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: entries.length,
                separatorBuilder: (_, _) => AppSpacing.vertical(context, 0.001),
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return AppDrawerHistoryTile(
                    title: entry.title,
                    timeLabel: entry.timeLabel,
                    isSelected: entry.isSelected,
                    onTap: entry.onTap,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
