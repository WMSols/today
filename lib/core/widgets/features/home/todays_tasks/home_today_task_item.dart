import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/buttons/app_icon_button.dart';
import 'package:today/core/widgets/common/app_section_card.dart';
import 'package:today/core/widgets/form/app_checkbox/app_checkbox.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';

class HomeTodayTaskItem extends StatelessWidget {
  const HomeTodayTaskItem({
    super.key,
    required this.task,
    required this.isSelected,
    required this.onTap,
    required this.onDone,
    required this.onSkip,
  });

  static const Duration _animDuration = Duration(milliseconds: 220);
  static const Curve _animCurve = Curves.easeOutCubic;

  final HomeTodayTaskEntity task;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDone;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == HomeTodayTaskStatus.completed;
    final isSkipped = task.status == HomeTodayTaskStatus.skipped;
    final showActions = isSelected && task.isPending;

    final bool checkboxValue;
    final Color checkboxBorderColor;
    final Color checkboxBackgroundColor;
    final Color checkboxCheckColor;

    if (isCompleted) {
      checkboxValue = true;
      checkboxBorderColor = AppColors.success;
      checkboxBackgroundColor = AppColors.success;
      checkboxCheckColor = AppColors.white;
    } else if (isSkipped) {
      checkboxValue = true;
      checkboxBorderColor = AppColors.error;
      checkboxBackgroundColor = AppColors.error;
      checkboxCheckColor = AppColors.white;
    } else {
      checkboxValue = isSelected;
      checkboxBorderColor = AppColors.white;
      checkboxBackgroundColor = AppColors.white;
      checkboxCheckColor = AppColors.black;
    }

    return AppSectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: _animDuration,
            switchInCurve: _animCurve,
            switchOutCurve: _animCurve,
            child: AppCheckbox(
              key: ValueKey(task.status),
              value: checkboxValue,
              onChanged: task.isPending ? (_) => onTap() : null,
              borderColor: checkboxBorderColor,
              backgroundColor: checkboxBackgroundColor,
              checkColor: checkboxCheckColor,
            ),
          ),
          AppSpacing.horizontal(context, 0.02),
          Expanded(
            child: GestureDetector(
              onTap: task.isPending ? onTap : null,
              behavior: HitTestBehavior.opaque,
              child: AnimatedDefaultTextStyle(
                duration: _animDuration,
                curve: _animCurve,
                style: AppTextStyles.bodyText(context).copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: AppResponsive.scaleSize(context, 15),
                  height: 1.2,
                  decoration: isSelected
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  decorationColor: AppColors.white,
                ),
                child: Text(task.title),
              ),
            ),
          ),
          AppSpacing.horizontal(context, 0.02),
          AnimatedSwitcher(
            duration: _animDuration,
            switchInCurve: _animCurve,
            switchOutCurve: _animCurve,
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  axis: Axis.horizontal,
                  sizeFactor: animation,
                  child: child,
                ),
              );
            },
            child: showActions
                ? _TaskActions(
                    key: const ValueKey('actions'),
                    onDone: onDone,
                    onSkip: onSkip,
                  )
                : _TaskTimeLabel(
                    key: const ValueKey('time'),
                    timeLabel: task.timeLabel,
                  ),
          ),
        ],
      ),
    );
  }
}

class _TaskTimeLabel extends StatelessWidget {
  const _TaskTimeLabel({super.key, required this.timeLabel});

  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    return Text(
      timeLabel,
      style: AppTextStyles.labelText(context).copyWith(
        color: AppColors.white,
        fontWeight: FontWeight.w500,
        fontSize: AppResponsive.scaleSize(context, 12),
      ),
    );
  }
}

class _TaskActions extends StatelessWidget {
  const _TaskActions({super.key, required this.onDone, required this.onSkip});

  final VoidCallback onDone;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final iconSize = AppResponsive.scaleSize(context, 18);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppIconButton(
          icon: Icons.check,
          onPressed: onDone,
          size: iconSize,
          paddingFactor: 0.6,
          backgroundColor: AppColors.success,
          color: AppColors.white,
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
