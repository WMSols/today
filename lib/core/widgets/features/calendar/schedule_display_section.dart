import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_icon_button.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/core/widgets/common/app_timeline/app_timeline_node.dart';
import 'package:today/core/widgets/common/app_timeline/app_vertical_timeline.dart';
import 'package:today/core/widgets/features/calendar/calendar_event_action_buttons.dart';
import 'package:today/core/widgets/form/app_checkbox/app_checkbox.dart';
import 'package:today/domain/entities/schedule_display_entity.dart';

class _ScheduleTimelineEntry {
  const _ScheduleTimelineEntry({
    required this.index,
    required this.dayDate,
    required this.slot,
    required this.weekdayLabel,
    required this.formattedDate,
  });

  final int index;
  final String dayDate;
  final ScheduleDisplaySlotEntity slot;
  final String weekdayLabel;
  final String formattedDate;
}

class ScheduleDisplaySection extends StatelessWidget {
  const ScheduleDisplaySection({
    super.key,
    required this.display,
    this.interactive = false,
    this.showHeading = true,
    this.selectedSlotKey = '',
    this.onSlotTap,
    this.onSlotEdit,
    this.onSlotDelete,
    this.onSlotComplete,
    this.onSlotSkip,
    this.isCalendarSlot,
  });

  final ScheduleDisplayEntity display;
  final bool interactive;
  final bool showHeading;
  final String selectedSlotKey;
  final ValueChanged<int>? onSlotTap;
  final ValueChanged<int>? onSlotEdit;
  final ValueChanged<int>? onSlotDelete;
  final ValueChanged<int>? onSlotComplete;
  final ValueChanged<int>? onSlotSkip;
  final bool Function(ScheduleDisplaySlotEntity slot)? isCalendarSlot;

  List<_ScheduleTimelineEntry> _buildEntries() {
    final entries = <_ScheduleTimelineEntry>[];
    var index = 0;
    for (final day in AppHelper.scheduleDaysWithSlots(display)) {
      final weekdayLabel = AppFormatter.scheduleDisplayWeekday(
        weekday: day.weekday,
        apiDate: day.date,
      );
      final formattedDate = AppFormatter.scheduleDisplayDate(day.date);
      for (final slot in day.slots) {
        if (slot.title.trim().isEmpty) continue;
        entries.add(
          _ScheduleTimelineEntry(
            index: index,
            dayDate: day.date,
            slot: slot,
            weekdayLabel: weekdayLabel,
            formattedDate: formattedDate,
          ),
        );
        index++;
      }
    }
    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final entries = _buildEntries();
    if (entries.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showHeading) ...[
          Text(
            AppTexts.scheduleDisplayHeading,
            style: AppTextStyles.bodyText(context).copyWith(
              color: context.onSurfaceColor,
              fontWeight: FontWeight.w600,
              fontSize: AppResponsive.scaleSize(context, 13),
            ),
          ),
          AppSpacing.vertical(context, 0.01),
        ],
        AppSectionCard(
          child: AppVerticalTimeline(
            children: List.generate(entries.length, (index) {
              final entry = entries[index];
              return _ScheduleSlotTimelineItem(
                entry: entry,
                isLast: index == entries.length - 1,
                interactive: interactive,
                isSelected: selectedSlotKey == '${entry.index}',
                isCalendar:
                    isCalendarSlot?.call(entry.slot) ??
                    AppHelper.isCalendarScheduleSlot(entry.slot),
                onTap: onSlotTap == null ? null : () => onSlotTap!(entry.index),
                onEdit: onSlotEdit == null
                    ? null
                    : () => onSlotEdit!(entry.index),
                onDelete: onSlotDelete == null
                    ? null
                    : () => onSlotDelete!(entry.index),
                onComplete: onSlotComplete == null
                    ? null
                    : () => onSlotComplete!(entry.index),
                onSkip: onSlotSkip == null
                    ? null
                    : () => onSlotSkip!(entry.index),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ScheduleSlotTimelineItem extends StatelessWidget {
  const _ScheduleSlotTimelineItem({
    required this.entry,
    required this.isLast,
    required this.interactive,
    required this.isSelected,
    required this.isCalendar,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onComplete,
    this.onSkip,
  });

  static const Duration _animDuration = Duration(milliseconds: 220);
  static const Curve _animCurve = Curves.easeOutCubic;

  final _ScheduleTimelineEntry entry;
  final bool isLast;
  final bool interactive;
  final bool isSelected;
  final bool isCalendar;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final accent = context.accentPalette.accent;
    final onAccent = context.accentPalette.buttonFilledForeground;
    final connectorColor = context.onSectionCardColor;
    final nodeSize = AppResponsive.scaleSize(context, 36);
    final rowBottomPadding = AppResponsive.scaleSize(context, 20);
    final slot = entry.slot;
    final timeLabel = slot.time?.trim() ?? '';
    final titleColor = context.onSectionCardColor;
    final showActions = interactive && isSelected;

    TextStyle titleStyle({
      double size = 15,
      TextDecoration? decoration = TextDecoration.lineThrough,
    }) {
      return AppTextStyles.bodyText(context).copyWith(
        color: titleColor,
        fontWeight: FontWeight.w600,
        fontSize: AppResponsive.scaleSize(context, size),
        height: 1.2,
        decoration: isSelected ? decoration : TextDecoration.none,
        decorationColor: titleColor,
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: nodeSize,
            child: Column(
              children: [
                AppTimelineNode(
                  color: accent,
                  size: nodeSize,
                  iconColor: onAccent,
                  borderColor: titleColor,
                  child: Icon(AppHelper.goalIconForTitle(slot.title)),
                ),
                if (!isLast)
                  Expanded(child: AppTimelineConnector(color: connectorColor)),
              ],
            ),
          ),
          AppSpacing.horizontal(context, 0.02),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: nodeSize,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: interactive ? onTap : null,
                          behavior: HitTestBehavior.opaque,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(slot.title, style: titleStyle()),
                          ),
                        ),
                      ),
                      if (interactive) ...[
                        AppSpacing.horizontal(context, 0.01),
                        AppCheckbox(
                          value: isSelected,
                          onChanged: onTap == null ? null : (_) => onTap!(),
                          borderColor: context.onSectionCardColor,
                          backgroundColor: isSelected
                              ? context.sectionCardColor
                              : Colors.transparent,
                          checkColor: context.onSectionCardColor,
                        ),
                      ],
                    ],
                  ),
                ),
                if (entry.formattedDate.isNotEmpty)
                  Text(
                    entry.formattedDate,
                    style: titleStyle(
                      size: 12,
                      decoration: TextDecoration.none,
                    ),
                  ),
                if (timeLabel.isNotEmpty || entry.weekdayLabel.isNotEmpty) ...[
                  AppSpacing.vertical(context, 0.004),
                  Text(
                    [
                      if (entry.weekdayLabel.isNotEmpty) entry.weekdayLabel,
                      if (timeLabel.isNotEmpty) timeLabel,
                    ].join(' · '),
                    style: titleStyle(
                      size: 12,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
                if (slot.description?.trim().isNotEmpty == true)
                  Padding(
                    padding: EdgeInsets.only(
                      top: AppResponsive.scaleSize(context, 6),
                    ),
                    child: Text(
                      slot.description!.trim(),
                      style: titleStyle(
                        size: 12,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                AnimatedSwitcher(
                  duration: _animDuration,
                  switchInCurve: _animCurve,
                  switchOutCurve: _animCurve,
                  transitionBuilder: (child, animation) {
                    return SizeTransition(
                      alignment: const Alignment(-1.0, -1.0),
                      sizeFactor: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: showActions
                      ? Padding(
                          key: const ValueKey('actions'),
                          padding: EdgeInsets.only(
                            top: AppResponsive.scaleSize(context, 8),
                          ),
                          child: isCalendar
                              ? CalendarEventActionButtons(
                                  onEdit: onEdit,
                                  onDelete: onDelete,
                                  onComplete: onComplete ?? () {},
                                  onSkip: onSkip ?? () {},
                                )
                              : _GoalSlotActions(
                                  onComplete: onComplete ?? () {},
                                  onSkip: onSkip ?? () {},
                                ),
                        )
                      : const SizedBox.shrink(key: ValueKey('empty')),
                ),
                if (!isLast) SizedBox(height: rowBottomPadding),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalSlotActions extends StatelessWidget {
  const _GoalSlotActions({required this.onComplete, required this.onSkip});

  final VoidCallback onComplete;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final iconSize = AppResponsive.scaleSize(context, 18);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIconButton(
          icon: Icons.check,
          onPressed: onComplete,
          size: iconSize,
          paddingFactor: 0.6,
          backgroundColor: AppColors.success,
          color: AppColors.white,
          useAccentPalette: false,
        ),
        AppSpacing.horizontal(context, 0.015),
        AppIconButton(
          icon: Icons.close,
          onPressed: onSkip,
          size: iconSize,
          paddingFactor: 0.6,
          backgroundColor: AppColors.error,
          color: AppColors.white,
          useAccentPalette: false,
        ),
      ],
    );
  }
}
