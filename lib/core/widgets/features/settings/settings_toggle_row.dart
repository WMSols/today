import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class SettingsToggleRow extends StatelessWidget {
  const SettingsToggleRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final trackWidth = AppResponsive.scaleSize(context, 64);
    final trackHeight = AppResponsive.scaleSize(context, 28);
    final knobFullWidth = AppResponsive.scaleSize(context, 39);
    final knobFullHeight = AppResponsive.scaleSize(context, 24);
    final knobHalfWidth = AppResponsive.scaleSize(context, 26);

    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText(context).copyWith(
            color: AppColors.grey,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 14),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: trackWidth,
            height: trackHeight,
            padding: EdgeInsets.symmetric(
              horizontal: AppResponsive.scaleSize(context, 3),
            ),
            decoration: BoxDecoration(
              color: value ? const Color(0xFF34C759) : AppColors.lightGrey,
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
                          color: AppColors.lightGrey,
                          width: AppResponsive.scaleSize(context, 1),
                        ),
                      ),
                    ),
                  ),
                AnimatedAlign(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  alignment: value
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: value ? knobFullWidth : knobHalfWidth,
                    height: knobFullHeight,
                    decoration: BoxDecoration(
                      color: AppColors.white,
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
      ],
    );
  }
}
