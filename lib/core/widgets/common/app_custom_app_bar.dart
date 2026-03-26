import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

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
    this.gemsCount = '8',
    this.streakCount = '8',
  }) : variant = AppCustomAppBarVariant.homeStatus,
       title = null,
       onBack = null,
       trailing = null,
       onTapUnlockPro = null;

  const AppCustomAppBar.backOnly({super.key, this.onBack})
    : variant = AppCustomAppBarVariant.backOnly,
      now = null,
      onTapDate = null,
      gemsCount = null,
      streakCount = null,
      title = null,
      trailing = null,
      onTapUnlockPro = null;

  const AppCustomAppBar.titleOnly({super.key, required this.title})
    : variant = AppCustomAppBarVariant.titleOnly,
      now = null,
      onTapDate = null,
      gemsCount = null,
      streakCount = null,
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
       gemsCount = null,
       streakCount = null,
       onTapUnlockPro = null;

  const AppCustomAppBar.unlockProChip({super.key, this.onTapUnlockPro})
    : variant = AppCustomAppBarVariant.unlockProChip,
      now = null,
      onTapDate = null,
      gemsCount = null,
      streakCount = null,
      title = null,
      onBack = null,
      trailing = null;

  final AppCustomAppBarVariant variant;
  final DateTime? now;
  final VoidCallback? onTapDate;
  final String? gemsCount;
  final String? streakCount;
  final String? title;
  final VoidCallback? onBack;
  final Widget? trailing;
  final VoidCallback? onTapUnlockPro;

  static const List<String> _days = [
    'MONDAY',
    'TUESDAY',
    'WEDNESDAY',
    'THURSDAY',
    'FRIDAY',
    'SATURDAY',
    'SUNDAY',
  ];

  static const List<String> _months = [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER',
  ];

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case AppCustomAppBarVariant.homeStatus:
        final current = now ?? DateTime.now();
        final dayLabel = _days[current.weekday - 1];
        final monthLabel = _months[current.month - 1];
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
                        color: AppColors.lightGrey,
                        fontWeight: FontWeight.w700,
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
                          color: isActive
                              ? AppColors.lightGrey
                              : AppColors.darkGrey,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            _TopCountBadge(iconPath: AppImages.gem, count: gemsCount ?? '8'),
            AppSpacing.horizontal(context, 0.02),
            _TopCountBadge(
              iconPath: AppImages.streak,
              count: streakCount ?? '8',
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
                color: AppColors.white,
                size: AppResponsive.iconSize(context),
              ),
            ),
          ],
        );
      case AppCustomAppBarVariant.titleOnly:
        return Text(
          title ?? '',
          style: AppTextStyles.headline(context).copyWith(
            color: AppColors.grey,
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
                  color: AppColors.white,
                  size: AppResponsive.iconSize(context),
                ),
              ),
            Expanded(
              child: Text(
                title ?? '',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading(context).copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w600,
                  fontSize: AppResponsive.scaleSize(context, 28),
                ),
              ),
            ),
            trailing ?? SizedBox(width: AppResponsive.scaleSize(context, 40)),
          ],
        );
      case AppCustomAppBarVariant.unlockProChip:
        return Align(
          alignment: Alignment.centerLeft,
          child: Material(
            color: const Color(0xFF1D1A27),
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
                      width: AppResponsive.iconSize(context, factor: 0.7),
                      height: AppResponsive.iconSize(context, factor: 0.7),
                    ),
                    AppSpacing.horizontal(context, 0.01),
                    Text(
                      'UNLOCK PRO',
                      style: AppTextStyles.labelText(context).copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w700,
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

class _TopCountBadge extends StatelessWidget {
  const _TopCountBadge({required this.iconPath, required this.count});

  final String iconPath;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.symmetric(context, h: 0.04, v: 0.01),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(
          AppResponsive.radius(context, factor: 5),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: AppResponsive.iconSize(context, factor: 0.8),
            height: AppResponsive.iconSize(context, factor: 0.8),
          ),
          AppSpacing.horizontal(context, 0.01),
          Text(
            count,
            style: AppTextStyles.bodyText(context).copyWith(
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
              fontSize: AppResponsive.scaleSize(context, 14),
            ),
          ),
        ],
      ),
    );
  }
}
