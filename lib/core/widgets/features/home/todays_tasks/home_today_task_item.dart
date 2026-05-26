import 'package:flutter/material.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_helper/app_helper.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/buttons/app_icon_button.dart';
import 'package:today/core/widgets/common/app_timeline/app_timeline_node.dart';
import 'package:today/core/widgets/common/app_timeline/app_vertical_timeline.dart';
import 'package:today/core/widgets/form/app_checkbox/app_checkbox.dart';
import 'package:today/domain/entities/home_today_task_entity.dart';

class _HomeTodayTaskRowColors {
  const _HomeTodayTaskRowColors({
    required this.nodeColor,
    required this.connectorColor,
    required this.timeColor,
    required this.titleColor,
    required this.iconColor,
    required this.checkboxValue,
    required this.checkboxBorderColor,
    required this.checkboxBackgroundColor,
    required this.checkboxCheckColor,
  });

  final Color nodeColor;
  final Color connectorColor;
  final Color timeColor;
  final Color titleColor;
  final Color iconColor;
  final bool checkboxValue;
  final Color checkboxBorderColor;
  final Color checkboxBackgroundColor;
  final Color checkboxCheckColor;
}

class HomeTodayTaskItem extends StatelessWidget {
  const HomeTodayTaskItem({
    super.key,
    required this.task,
    required this.isLast,
    required this.isSelected,
    required this.onTap,
    required this.onDone,
    required this.onSkip,
  });

  static const Duration _animDuration = Duration(milliseconds: 220);
  static const Curve _animCurve = Curves.easeOutCubic;

  final HomeTodayTaskEntity task;
  final bool isLast;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDone;
  final VoidCallback onSkip;

  static _HomeTodayTaskRowColors _resolveColors(
    BuildContext context, {
    required HomeTodayTaskEntity task,
    required bool isSelected,
  }) {
    final accent = context.accentPalette.accent;
    final success = AppColors.success;
    final error = AppColors.error;
    final onAccent = context.accentPalette.buttonFilledForeground;
    final isCompleted = task.status == HomeTodayTaskStatus.completed;
    final isSkipped = task.status == HomeTodayTaskStatus.skipped;

    if (isCompleted) {
      return _HomeTodayTaskRowColors(
        nodeColor: success,
        connectorColor: success,
        timeColor: success,
        titleColor: success,
        iconColor: AppColors.white,
        checkboxValue: true,
        checkboxBorderColor: success,
        checkboxBackgroundColor: success,
        checkboxCheckColor: AppColors.white,
      );
    }

    if (isSkipped) {
      return _HomeTodayTaskRowColors(
        nodeColor: error,
        connectorColor: error,
        timeColor: error,
        titleColor: error,
        iconColor: AppColors.white,
        checkboxValue: true,
        checkboxBorderColor: error,
        checkboxBackgroundColor: error,
        checkboxCheckColor: AppColors.white,
      );
    }

    if (isSelected) {
      return _HomeTodayTaskRowColors(
        nodeColor: accent,
        connectorColor: accent,
        timeColor: accent,
        titleColor: context.onSurfaceColor,
        iconColor: onAccent,
        checkboxValue: true,
        checkboxBorderColor: accent,
        checkboxBackgroundColor: accent,
        checkboxCheckColor: onAccent,
      );
    }

    return _HomeTodayTaskRowColors(
      nodeColor: accent,
      connectorColor: accent,
      timeColor: context.mutedOnSurfaceColor,
      titleColor: context.onSurfaceColor,
      iconColor: onAccent,
      checkboxValue: false,
      checkboxBorderColor: accent,
      checkboxBackgroundColor: Colors.transparent,
      checkboxCheckColor: onAccent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = _resolveColors(context, task: task, isSelected: isSelected);
    final showActions = isSelected && task.isPending;
    final nodeSize = AppResponsive.scaleSize(context, 36);
    final rowBottomPadding = AppResponsive.scaleSize(context, 20);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: nodeSize,
            child: Column(
              children: [
                AnimatedContainer(
                  duration: _animDuration,
                  curve: _animCurve,
                  child: AppTimelineNode(
                    color: colors.nodeColor,
                    size: nodeSize,
                    iconColor: colors.iconColor,
                    child: Icon(
                      AppHelper.homeTodayTaskIconForTitle(task.title),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: AppTimelineConnector(color: colors.connectorColor),
                  ),
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
                          onTap: task.isPending ? onTap : null,
                          behavior: HitTestBehavior.opaque,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: AnimatedDefaultTextStyle(
                              duration: _animDuration,
                              curve: _animCurve,
                              style: AppTextStyles.bodyText(context).copyWith(
                                color: colors.titleColor,
                                fontWeight: FontWeight.w600,
                                fontSize: AppResponsive.scaleSize(context, 15),
                                height: 1.2,
                                decoration:
                                    isSelected ||
                                        task.status ==
                                            HomeTodayTaskStatus.skipped ||
                                        task.status ==
                                            HomeTodayTaskStatus.completed
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: isSelected
                                    ? colors.titleColor
                                    : task.status == HomeTodayTaskStatus.skipped
                                    ? AppColors.error
                                    : AppColors.success,
                              ),
                              child: Text(task.title),
                            ),
                          ),
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: _animDuration,
                        switchInCurve: _animCurve,
                        switchOutCurve: _animCurve,
                        child: AppCheckbox(
                          key: ValueKey(task.status),
                          value: colors.checkboxValue,
                          onChanged: task.isPending ? (_) => onTap() : null,
                          borderColor: colors.checkboxBorderColor,
                          backgroundColor: colors.checkboxBackgroundColor,
                          checkColor: colors.checkboxCheckColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  task.timeLabel,
                  style: AppTextStyles.labelText(context).copyWith(
                    color: colors.timeColor,
                    fontWeight: FontWeight.w500,
                    fontSize: AppResponsive.scaleSize(context, 12),
                    height: 0.5,
                  ),
                ),
                AnimatedSwitcher(
                  duration: _animDuration,
                  switchInCurve: _animCurve,
                  switchOutCurve: _animCurve,
                  transitionBuilder: (child, animation) {
                    return SizeTransition(
                      axisAlignment: -1,
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
                          child: _TaskActions(onDone: onDone, onSkip: onSkip),
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

class _TaskActions extends StatelessWidget {
  const _TaskActions({required this.onDone, required this.onSkip});

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
