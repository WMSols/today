import 'package:flutter/material.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';

class SettingsBody extends StatelessWidget {
  const SettingsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: AppTextStyles.headline(context).copyWith(color: AppColors.white),
        ),
        const Spacer(),
        Text(
          'Settings UI will be implemented from Figma.',
          style: AppTextStyles.bodyText(context).copyWith(color: AppColors.white),
        ),
      ],
    );
  }
}

