import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/widgets/common/app_user_profile_image.dart';

class SettingsProfileHeader extends StatelessWidget {
  const SettingsProfileHeader({
    super.key,
    required this.username,
    this.photoUrl,
  });

  final String username;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarSize = AppResponsive.scaleSize(context, 100);

    return Column(
      children: [
        Center(
          child: AppUserProfileImage(
            size: avatarSize,
            photoUrl: photoUrl,
          ),
        ),
        AppSpacing.vertical(context, 0.015),
        Text(
          username,
          style: AppTextStyles.heading(context).copyWith(
            color: isDark ? AppColors.white : AppColors.black,
            fontWeight: FontWeight.w600,
            fontSize: AppResponsive.scaleSize(context, 16),
          ),
        ),
      ],
    );
  }
}
