import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/presentation/controllers/splash/splash_controller.dart';

/// Netflix-style staggered letter reveal for the splash brand name.
class SplashBrandTitle extends GetView<SplashController> {
  const SplashBrandTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final style = AppTextStyles.headline(context).copyWith(
      fontWeight: FontWeight.w700,
      fontSize: AppResponsive.scaleSize(context, 32),
      color: AppColors.white,
    );

    return Obx(
      () => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(controller.brandCharacters.length, (index) {
          final t = controller.brandLetterProgress(index);
          return Opacity(
            opacity: t,
            child: Transform.translate(
              offset: Offset(0, 10 * (1 - t)),
              child: Transform.scale(
                scale: 1.15 - (0.15 * t),
                child: Text(controller.brandCharacters[index], style: style),
              ),
            ),
          );
        }),
      ),
    );
  }
}
