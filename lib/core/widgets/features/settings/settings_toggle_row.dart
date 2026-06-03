import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/form/app_checkbox/app_checkbox.dart';

/// Custom settings switch used as the trailing control on [SettingsControlTile].
class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    super.key,
    required this.value,
    required this.onChanged,
    this.showSystemCheckbox = false,
    this.systemCheckboxValue = false,
    this.onSystemChanged,
    this.toggleLocked = false,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  /// When true, shows [AppCheckbox] for [AppTexts.themeSystem] before the switch.
  final bool showSystemCheckbox;
  final bool systemCheckboxValue;
  final ValueChanged<bool?>? onSystemChanged;

  /// When true, the switch is visual-only (e.g. following device while in system theme).
  final bool toggleLocked;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inactiveTrack = isDark ? AppColors.lightGrey : AppColors.grey;
    const knobColor = AppColors.secondary;
    final outlineColor = isDark ? AppColors.lightGrey : AppColors.grey;

    final trackWidth = AppResponsive.scaleSize(context, 64);
    final trackHeight = AppResponsive.scaleSize(context, 28);
    final knobFullWidth = AppResponsive.scaleSize(context, 39);
    final knobFullHeight = AppResponsive.scaleSize(context, 24);
    final knobHalfWidth = AppResponsive.scaleSize(context, 26);

    final toggle = GestureDetector(
      onTap: toggleLocked ? null : () => onChanged(!value),
      child: AnimatedOpacity(
        opacity: toggleLocked ? 0.45 : 1,
        duration: const Duration(milliseconds: 180),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: trackWidth,
          height: trackHeight,
          padding: EdgeInsets.symmetric(
            horizontal: AppResponsive.scaleSize(context, 3),
          ),
          decoration: BoxDecoration(
            color: value ? const Color(0xFF34C759) : inactiveTrack,
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, factor: 5),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!value)
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: AppResponsive.scaleSize(context, 21),
                    height: AppResponsive.scaleSize(context, 9),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: outlineColor,
                        width: AppResponsive.scaleSize(context, 1),
                      ),
                    ),
                  ),
                ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: value ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: value ? knobFullWidth : knobHalfWidth,
                  height: knobFullHeight,
                  decoration: BoxDecoration(
                    color: knobColor,
                    borderRadius: BorderRadius.circular(
                      AppResponsive.radius(context, factor: 5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (showSystemCheckbox && onSystemChanged != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppCheckbox(
            value: systemCheckboxValue,
            label: AppTexts.themeSystem,
            backgroundColor: AppColors.white,
            borderColor: AppColors.white,
            checkColor: AppColors.black,
            onChanged: onSystemChanged!,
            labelColor: AppColors.white,
          ),
          SizedBox(width: AppResponsive.scaleSize(context, 8)),
          toggle,
        ],
      );
    }

    return toggle;
  }
}
