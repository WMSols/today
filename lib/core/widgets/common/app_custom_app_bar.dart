import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_formatter/app_formatter.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/common/app_user_profile_image.dart';
import 'package:today/core/widgets/features/home/header/home_notification_button.dart';

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
    required this.greetingName,
    required this.greetingTimeOfDay,
    this.profilePhotoUrl,
    this.onTapProfile,
    this.onTapNotifications,
    this.hasUnreadNotifications = false,
  }) : variant = AppCustomAppBarVariant.homeStatus,
       title = null,
       onBack = null,
       trailing = null,
       onTapUnlockPro = null;

  const AppCustomAppBar.backOnly({super.key, this.onBack})
    : variant = AppCustomAppBarVariant.backOnly,
      greetingName = null,
      greetingTimeOfDay = null,
      profilePhotoUrl = null,
      onTapProfile = null,
      onTapNotifications = null,
      hasUnreadNotifications = false,
      title = null,
      trailing = null,
      onTapUnlockPro = null;

  const AppCustomAppBar.titleOnly({super.key, required this.title})
    : variant = AppCustomAppBarVariant.titleOnly,
      greetingName = null,
      greetingTimeOfDay = null,
      profilePhotoUrl = null,
      onTapProfile = null,
      onTapNotifications = null,
      hasUnreadNotifications = false,
      onBack = null,
      trailing = null,
      onTapUnlockPro = null;

  const AppCustomAppBar.titleWithActions({
    super.key,
    required this.title,
    this.onBack,
    this.trailing,
  }) : variant = AppCustomAppBarVariant.titleWithActions,
       greetingName = null,
       greetingTimeOfDay = null,
       profilePhotoUrl = null,
       onTapProfile = null,
       onTapNotifications = null,
       hasUnreadNotifications = false,
       onTapUnlockPro = null;

  const AppCustomAppBar.unlockProChip({super.key, this.onTapUnlockPro})
    : variant = AppCustomAppBarVariant.unlockProChip,
      greetingName = null,
      greetingTimeOfDay = null,
      profilePhotoUrl = null,
      onTapProfile = null,
      onTapNotifications = null,
      hasUnreadNotifications = false,
      title = null,
      onBack = null,
      trailing = null;

  final AppCustomAppBarVariant variant;
  final String? greetingName;
  final String? greetingTimeOfDay;
  final String? profilePhotoUrl;
  final VoidCallback? onTapProfile;
  final VoidCallback? onTapNotifications;
  final bool hasUnreadNotifications;
  final String? title;
  final VoidCallback? onBack;
  final Widget? trailing;
  final VoidCallback? onTapUnlockPro;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = isDark ? AppColors.darkGrey : AppColors.grey;
    final onSurface = isDark ? AppColors.white : AppColors.black;
    final muted = isDark ? AppColors.grey : AppColors.black;

    switch (variant) {
      case AppCustomAppBarVariant.homeStatus:
        final outline = isDark ? AppColors.grey : AppColors.black;
        final dividerColor = isDark
            ? AppColors.darkGrey
            : AppColors.grey.withValues(alpha: 0.3);
        final avatarSize = AppResponsive.scaleSize(context, 44);
        final normalStyle = AppTextStyles.bodyText(context).copyWith(
          color: outline,
          fontWeight: FontWeight.w400,
          fontSize: AppResponsive.scaleSize(context, 14),
          height: 1.3,
        );
        final greetingStyle = AppTextStyles.bodyText(context).copyWith(
          color: outline,
          fontWeight: FontWeight.w600,
          fontSize: AppResponsive.scaleSize(context, 22),
          height: 1.3,
        );
        final nameStyle = greetingStyle.copyWith(
          color: onSurface,
          fontWeight: FontWeight.w600,
          fontSize: AppResponsive.scaleSize(context, 18),
          height: 1.15,
        );
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(greetingTimeOfDay ?? '', style: greetingStyle),
                          AppSpacing.horizontal(context, 0.015),
                          Image.asset(
                            AppFormatter.timeOfDayGreetingImage(),
                            width: AppResponsive.scaleSize(context, 26),
                            height: AppResponsive.scaleSize(context, 26),
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          style: normalStyle,
                          children: [
                            TextSpan(text: AppTexts.homeGreetingHeyPrefix),
                            TextSpan(
                              text: greetingName ?? '',
                              style: nameStyle,
                            ),
                            TextSpan(text: AppTexts.homeGreetingHeySuffix),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                HomeNotificationButton(
                  onPressed: onTapNotifications,
                  hasUnread: hasUnreadNotifications,
                ),
                AppSpacing.horizontal(context, 0.02),
                AppUserProfileImage(
                  size: avatarSize,
                  photoUrl: profilePhotoUrl,
                  onTap: onTapProfile,
                ),
              ],
            ),
            AppSpacing.vertical(context, 0.01),
            Divider(
              color: dividerColor,
              height: AppResponsive.scaleSize(context, 1),
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
                  fontSize: AppResponsive.scaleSize(context, 18),
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
