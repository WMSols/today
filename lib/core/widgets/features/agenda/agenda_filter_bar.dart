import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/presentation/controllers/agenda/agenda_controller.dart';

class AgendaFilterBar extends GetView<AgendaController> {
  const AgendaFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.filter.value;
      return Row(
        children: [
          _Chip(
            label: AppTexts.agendaFilterAll,
            isSelected: selected == AgendaTaskFilter.all,
            onTap: () => controller.setFilter(AgendaTaskFilter.all),
          ),
          AppSpacing.horizontal(context, 0.015),
          _Chip(
            label: AppTexts.agendaFilterCalendar,
            isSelected: selected == AgendaTaskFilter.calendar,
            onTap: () => controller.setFilter(AgendaTaskFilter.calendar),
          ),
          AppSpacing.horizontal(context, 0.015),
          _Chip(
            label: AppTexts.agendaFilterGoals,
            isSelected: selected == AgendaTaskFilter.goals,
            onTap: () => controller.setFilter(AgendaTaskFilter.goals),
          ),
        ],
      );
    });
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = context.accentPalette.accent;
    final onAccent = context.accentPalette.buttonFilledForeground;

    return Material(
      color: isSelected ? accent : context.sectionCardColor,
      borderRadius: BorderRadius.circular(
        AppResponsive.radius(context, factor: 4),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 4),
        ),
        child: Padding(
          padding: AppSpacing.symmetric(context, h: 0.025, v: 0.006),
          child: Text(
            label,
            style: AppTextStyles.bodyText(context).copyWith(
              color: isSelected ? onAccent : context.onSectionCardColor,
              fontWeight: FontWeight.w600,
              fontSize: AppResponsive.scaleSize(context, 12),
            ),
          ),
        ),
      ),
    );
  }
}
