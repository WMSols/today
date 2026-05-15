import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

enum AppCustomAppBarVariant {
  homeStatus,
  backOnly,
  titleOnly,
  titleWithActions,
  unlockProChip,
}

class AppCustomAppBar extends StatelessWidget {
  const AppCustomAppBar.homeStatus({
    super.key,
    required this.now,
    required this.onTapDate,
  }) : variant = AppCustomAppBarVariant.homeStatus,
       title = null,
       onBack = null,
       trailing = null,
       onTapUnlockPro = null;

  const AppCustomAppBar.backOnly({super.key, this.onBack})
    : variant = AppCustomAppBarVariant.backOnly,
      now = null,
      onTapDate = null,
      title = null,
      trailing = null,
      onTapUnlockPro = null;

  const AppCustomAppBar.titleOnly({super.key, required this.title})
    : variant = AppCustomAppBarVariant.titleOnly,
      now = null,
      onTapDate = null,
      onBack = null,
      trailing = null,
      onTapUnlockPro = null;

  const AppCustomAppBar.titleWithActions({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
  }) : variant = AppCustomAppBarVariant.titleWithActions,
       now = null,
       onTapDate = null,
       onTapUnlockPro = null;

  const AppCustomAppBar.unlockProChip({super.key, this.onTapUnlockPro})
    : variant = AppCustomAppBarVariant.unlockProChip,
      now = null,
      onTapDate = null,
      title = null,
      onBack = null,
      trailing = null;

  final AppCustomAppBarVariant variant;
  final DateTime? now;
  final VoidCallback? onTapDate;
  final String? title;
  final VoidCallback? onBack;
  final Widget? trailing;
  final VoidCallback? onTapUnlockPro;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final outline = isDark ? AppColors.lightGrey : AppColors.grey;
    final card = isDark ? AppColors.darkGrey : AppColors.grey;
    final onSurface = isDark ? AppColors.white : AppColors.black;
    final muted = AppColors.grey;

    switch (variant) {
      case AppCustomAppBarVariant.homeStatus:
        final current = now ?? DateTime.now();
        final dayLabel = AppFormatter.dayNameFull(current.weekday);
        final monthLabel = AppFormatter.monthNameFull(current.month);
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTapDate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$dayLabel, ${current.day} $monthLabel',
                      style: AppTextStyles.bodyText(context).copyWith(
                        color: outline,
                        fontWeight: FontWeight.w600,
                        fontSize: AppResponsive.scaleSize(context, 10),
                      ),
                    ),
                    AppSpacing.vertical(context, 0.01),
                    Row(
                      children: List.generate(7, (index) {
                        final isActive = index < current.weekday;
                        return Container(
                          width: AppResponsive.scaleSize(context, 6),
                          height: AppResponsive.scaleSize(context, 6),
                          margin: EdgeInsets.only(
                            right: AppResponsive.scaleSize(context, 6),
                          ),
                          color: isActive ? outline : card,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      case AppCustomAppBarVariant.backOnly:
        return Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: Icon(
                Icons.arrow_back,
                color: onSurface,
                size: AppResponsive.iconSize(context),
              ),
            ),
          ],
        );
      case AppCustomAppBarVariant.titleOnly:
        return Text(
          title ?? '',
          style: AppTextStyles.headline(context).copyWith(
            color: muted,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 28),
          ),
        );
      case AppCustomAppBarVariant.titleWithActions:
        return Row(
          children: [
            if (onBack != null)
              IconButton(
                onPressed: onBack,
                icon: Icon(
                  Icons.arrow_back,
                  color: onSurface,
                  size: AppResponsive.iconSize(context),
                ),
              ),
            Expanded(
              child: Text(
                title ?? '',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading(context).copyWith(
                  color: muted,
                  fontWeight: FontWeight.w600,
                  fontSize: AppResponsive.scaleSize(context, 19),
                ),
              ),
            ),
            trailing ?? SizedBox(width: AppResponsive.scaleSize(context, 40)),
          ],
        );
      case AppCustomAppBarVariant.unlockProChip:
        return Align(
          alignment: Alignment.center,
          child: Material(
            color: card,
            borderRadius: BorderRadius.circular(
              AppResponsive.radius(context, factor: 5),
            ),
            child: InkWell(
              onTap: onTapUnlockPro,
              borderRadius: BorderRadius.circular(
                AppResponsive.radius(context, factor: 5),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.scaleSize(context, 12),
                  vertical: AppResponsive.scaleSize(context, 8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppImages.unlockPro,
                      width: AppResponsive.scaleSize(context, 10),
                      height: AppResponsive.scaleSize(context, 10),
                    ),
                    AppSpacing.horizontal(context, 0.01),
                    Text(
                      AppTexts.unlockPro,
                      style: AppTextStyles.labelText(context).copyWith(
                        color: onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: AppResponsive.scaleSize(context, 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
    }
  }
}
