import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/buttons/app_text_button.dart';

/// Reusable date-time picker presented as a bottom sheet with scrollable wheels
/// (date + time), similar to Instagram's picker style.
/// [initial] is the initial date-time; [onSelected] is called with the chosen DateTime on Done.
/// Returns the selected [DateTime] from [show] or null if dismissed.
class AppDateTimePicker {
  /// Shows the picker and returns the selected [DateTime] or null.
  /// [title] is the header text shown in the picker (e.g. "Select Visit Time"
  /// or "Scheduled Delivery Date").
  static Future<DateTime?> show(
    BuildContext context, {
    String? title,
    DateTime? initial,
    DateTime? minDate,
    DateTime? maxDate,
  }) async {
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _AppDateTimePickerSheet(
        title: title ?? AppTexts.selectDateTime,
        initial: initial ?? DateTime.now(),
        minDate: minDate,
        maxDate: maxDate,
      ),
    );
    return picked;
  }
}

class _AppDateTimePickerSheet extends StatefulWidget {
  const _AppDateTimePickerSheet({
    required this.title,
    required this.initial,
    this.minDate,
    this.maxDate,
  });

  final String title;
  final DateTime initial;
  final DateTime? minDate;
  final DateTime? maxDate;

  @override
  State<_AppDateTimePickerSheet> createState() =>
      _AppDateTimePickerSheetState();
}

class _AppDateTimePickerSheetState extends State<_AppDateTimePickerSheet> {
  late DateTime _selected;
  late FixedExtentScrollController _dateController;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  late FixedExtentScrollController _periodController;
  static const int _daysToShow = 365 * 2;
  static const int _hourCount12 = 12; // 12, 1, 2, ..., 11
  static const int _minuteCount = 60;
  static const int _periodCount = 2; // AM, PM

  /// 24h hour (0-23) → display index (0 = 12, 1 = 1, ..., 11 = 11).
  static int _hour24ToDisplayIndex(int hour24) {
    if (hour24 == 0 || hour24 == 12) return 0;
    return hour24 % 12;
  }

  /// Display index + isPM → 24h hour (0-23).
  static int _displayIndexToHour24(int displayIndex, bool isPM) {
    if (isPM) {
      return displayIndex == 0 ? 12 : displayIndex + 12;
    }
    return displayIndex == 0 ? 0 : displayIndex;
  }

  @override
  void initState() {
    super.initState();
    _selected = widget.initial;
    final start =
        widget.minDate ?? DateTime.now().subtract(const Duration(days: 365));
    final d0 = DateTime(_selected.year, _selected.month, _selected.day);
    final s0 = DateTime(start.year, start.month, start.day);
    final dateIndex = d0.difference(s0).inDays.clamp(0, _daysToShow - 1);
    _dateController = FixedExtentScrollController(
      initialItem: math.min(dateIndex, _daysToShow - 1),
    );
    _hourController = FixedExtentScrollController(
      initialItem: _hour24ToDisplayIndex(_selected.hour.clamp(0, 23)),
    );
    _minuteController = FixedExtentScrollController(
      initialItem: _selected.minute.clamp(0, 59),
    );
    _periodController = FixedExtentScrollController(
      initialItem: _selected.hour < 12 ? 0 : 1,
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _hourController.dispose();
    _minuteController.dispose();
    _periodController.dispose();
    super.dispose();
  }

  List<DateTime> get _dates {
    final start =
        widget.minDate ?? DateTime.now().subtract(const Duration(days: 365));
    return List.generate(_daysToShow, (i) => start.add(Duration(days: i)));
  }

  void _onDateIndexChanged(int index) {
    final list = _dates;
    if (index < 0 || index >= list.length) return;
    final d = list[index];
    setState(() {
      _selected = DateTime(
        d.year,
        d.month,
        d.day,
        _selected.hour,
        _selected.minute,
      );
    });
  }

  void _onHourChanged(int displayIndex) {
    final isPM = _selected.hour >= 12;
    final hour24 = _displayIndexToHour24(displayIndex.clamp(0, 11), isPM);
    setState(() {
      _selected = DateTime(
        _selected.year,
        _selected.month,
        _selected.day,
        hour24,
        _selected.minute,
      );
    });
  }

  void _onPeriodChanged(int periodIndex) {
    final displayIndex = _hour24ToDisplayIndex(_selected.hour);
    final hour24 = _displayIndexToHour24(displayIndex, periodIndex == 1);
    setState(() {
      _selected = DateTime(
        _selected.year,
        _selected.month,
        _selected.day,
        hour24,
        _selected.minute,
      );
    });
  }

  void _onMinuteChanged(int minute) {
    setState(() {
      _selected = DateTime(
        _selected.year,
        _selected.month,
        _selected.day,
        _selected.hour,
        minute.clamp(0, 59),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppResponsive.scaleSize(context, 20)),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: AppSpacing.symmetric(context, h: 0.04, v: 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextButton(
                    label: AppTexts.cancel,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Text(
                    widget.title,
                    style: AppTextStyles.bodyText(
                      context,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  AppTextButton(
                    label: AppTexts.save,
                    onPressed: () => Navigator.of(context).pop(_selected),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            SizedBox(
              height: AppResponsive.scaleSize(context, 220),
              child: Row(
                children: [
                  Expanded(
                    child: ListWheelScrollView.useDelegate(
                      controller: _dateController,
                      itemExtent: AppResponsive.scaleSize(context, 44),
                      diameterRatio: 1.2,
                      perspective: 0.003,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: _onDateIndexChanged,
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: _dates.length,
                        builder: (context, index) {
                          final d = _dates[index];
                          final isSelected =
                              d.year == _selected.year &&
                              d.month == _selected.month &&
                              d.day == _selected.day;
                          return Center(
                            child: Text(
                              AppFormatter.shortDate(d),
                              style: AppTextStyles.bodyText(context).copyWith(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.grey,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: AppResponsive.scaleSize(context, 50),
                          child: ListWheelScrollView.useDelegate(
                            controller: _hourController,
                            itemExtent: AppResponsive.scaleSize(context, 44),
                            diameterRatio: 1.2,
                            perspective: 0.003,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: _onHourChanged,
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: _hourCount12,
                              builder: (context, index) {
                                final hourLabel = index == 0
                                    ? '12'
                                    : index.toString();
                                final isSelected =
                                    index ==
                                    _hour24ToDisplayIndex(_selected.hour);
                                return Center(
                                  child: Text(
                                    hourLabel,
                                    style: AppTextStyles.bodyText(context)
                                        .copyWith(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.grey,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Text(
                          ':',
                          style: AppTextStyles.bodyText(context).copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize:
                                AppResponsive.screenWidth(context) * 0.053,
                          ),
                        ),
                        SizedBox(
                          width: AppResponsive.scaleSize(context, 70),
                          child: ListWheelScrollView.useDelegate(
                            controller: _minuteController,
                            itemExtent: AppResponsive.scaleSize(context, 44),
                            diameterRatio: 1.2,
                            perspective: 0.003,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: _onMinuteChanged,
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: _minuteCount,
                              builder: (context, index) {
                                final isSelected = index == _selected.minute;
                                return Center(
                                  child: Text(
                                    index.toString().padLeft(2, '0'),
                                    style: AppTextStyles.bodyText(context)
                                        .copyWith(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.grey,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: AppResponsive.scaleSize(context, 56),
                          child: ListWheelScrollView.useDelegate(
                            controller: _periodController,
                            itemExtent: AppResponsive.scaleSize(context, 44),
                            diameterRatio: 1.2,
                            perspective: 0.003,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: _onPeriodChanged,
                            childDelegate: ListWheelChildBuilderDelegate(
                              childCount: _periodCount,
                              builder: (context, index) {
                                final periodLabel = index == 0
                                    ? AppTexts.periodAm
                                    : AppTexts.periodPm;
                                final isSelected =
                                    (index == 0 && _selected.hour < 12) ||
                                    (index == 1 && _selected.hour >= 12);
                                return Center(
                                  child: Text(
                                    periodLabel,
                                    style: AppTextStyles.bodyText(context)
                                        .copyWith(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.grey,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.vertical(context, 0.02),
          ],
        ),
      ),
    );
  }
}
