import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class AppBottomNavItem extends StatelessWidget {
  const AppBottomNavItem({
    super.key,
    required this.index,
    required this.currentIndex,
    required this.label,
    required this.iconPath,
    required this.onTap,
  });

  final int index;
  final int currentIndex;
  final String label;
  final String iconPath;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    final iconSize = AppResponsive.iconSize(
      context,
      factor: isSelected ? 1 : 1.3,
    );
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.symmetric(
            horizontal: AppResponsive.scaleSize(context, 2),
            vertical: AppResponsive.scaleSize(context, 2),
          ),
          padding: EdgeInsets.symmetric(
            vertical: AppResponsive.scaleSize(context, 4),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppResponsive.radius(context)),
            color: Colors.transparent,
          ),
          child: Center(
            child: AnimatedSize(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    iconPath,
                    width: iconSize,
                    height: iconSize,
                    fit: BoxFit.contain,
                  ),
                  if (isSelected) ...[
                    SizedBox(height: AppResponsive.scaleSize(context, 2)),
                    Text(
                      label,
                      style: AppTextStyles.hintText(context).copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: AppResponsive.screenWidth(context) * 0.028,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

