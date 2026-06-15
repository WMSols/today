import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/core/widgets/common/app_timeline/app_timeline_node.dart';
import 'package:today/core/widgets/common/app_timeline/app_vertical_timeline.dart';
import 'package:today/domain/entities/schedule_display_entity.dart';

class _ScheduleTimelineEntry {
  const _ScheduleTimelineEntry({
    required this.slot,
    required this.weekdayLabel,
    required this.formattedDate,
  });

  final ScheduleDisplaySlotEntity slot;
  final String weekdayLabel;
  final String formattedDate;
}

class ScheduleDisplaySection extends StatelessWidget {
  const ScheduleDisplaySection({super.key, required this.display});

  final ScheduleDisplayEntity display;

  List<_ScheduleTimelineEntry> _buildEntries() {
    final entries = <_ScheduleTimelineEntry>[];
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
            slot: slot,
            weekdayLabel: weekdayLabel,
            formattedDate: formattedDate,
          ),
        );
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
        Text(
          AppTexts.scheduleDisplayHeading,
          style: AppTextStyles.bodyText(context).copyWith(
            color: context.onSurfaceColor,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 13),
          ),
        ),
        AppSpacing.vertical(context, 0.01),
        AppSectionCard(
          child: AppVerticalTimeline(
            children: List.generate(entries.length, (index) {
              return _ScheduleSlotTimelineItem(
                entry: entries[index],
                isLast: index == entries.length - 1,
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ScheduleSlotTimelineItem extends StatelessWidget {
  const _ScheduleSlotTimelineItem({required this.entry, required this.isLast});

  final _ScheduleTimelineEntry entry;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final accent = context.accentPalette.accent;
    final onAccent = context.accentPalette.buttonFilledForeground;
    final nodeSize = AppResponsive.scaleSize(context, 36);
    final rowBottomPadding = AppResponsive.scaleSize(context, 20);
    final slot = entry.slot;
    final timeLabel = slot.time?.trim() ?? '';
    final titleColor = context.onSectionCardColor;

    TextStyle titleStyle({double size = 15}) {
      return AppTextStyles.bodyText(context).copyWith(
        color: titleColor,
        fontWeight: FontWeight.w600,
        fontSize: AppResponsive.scaleSize(context, size),
        height: 1.2,
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
                  child: Icon(AppHelper.goalIconForTitle(slot.title)),
                ),
                if (!isLast)
                  Expanded(child: AppTimelineConnector(color: accent)),
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
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(slot.title, style: titleStyle()),
                  ),
                ),
                if (entry.formattedDate.isNotEmpty)
                  Text(entry.formattedDate, style: titleStyle(size: 12)),
                if (timeLabel.isNotEmpty || entry.weekdayLabel.isNotEmpty) ...[
                  AppSpacing.vertical(context, 0.004),
                  Text(
                    [
                      if (entry.weekdayLabel.isNotEmpty) entry.weekdayLabel,
                      if (timeLabel.isNotEmpty) timeLabel,
                    ].join(' · '),
                    style: titleStyle(size: 12),
                  ),
                ],
                if (slot.description?.trim().isNotEmpty == true)
                  Padding(
                    padding: EdgeInsets.only(
                      top: AppResponsive.scaleSize(context, 6),
                    ),
                    child: Text(
                      slot.description!.trim(),
                      style: titleStyle(size: 12),
                    ),
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
