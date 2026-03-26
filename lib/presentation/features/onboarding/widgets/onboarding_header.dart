import 'package:flutter/material.dart';

import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(AppTexts.appName, style: AppTextStyles.headline(context));
  }
}
