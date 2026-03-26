import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/network/connectivity_service.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_images/app_images.dart';
import 'package:today/core/utils/app_responsive/app_responsive.dart';
import 'package:today/core/utils/app_spacing/app_spacing.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

class AppEmptyWidget extends StatelessWidget {
  const AppEmptyWidget({
    super.key,
    this.message = AppTexts.noDataYet,
    this.imagePath,
  });

  final String message;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isNoConnection =
          Get.isRegistered<ConnectivityService>() &&
          !Get.find<ConnectivityService>().isOnline.value;
      final illustrationPath = isNoConnection
          ? AppImages.noInternet
          : (imagePath ?? AppImages.noDataYet);
      final displayMessage = isNoConnection ? AppTexts.noInternet : message;
      return _buildContent(
        context,
        illustrationPath: illustrationPath,
        message: displayMessage,
      );
    });
  }

  Widget _buildContent(
    BuildContext context, {
    required String illustrationPath,
    required String message,
  }) {
    final size = AppResponsive.emptyIconSize(context);
    return Center(
      child: Padding(
        padding: AppSpacing.symmetric(context, h: 0.08, v: 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              illustrationPath,
              width: size * 3,
              height: size * 3,
              fit: BoxFit.contain,
            ),
            AppSpacing.vertical(context, 0.01),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyText(
                context,
              ).copyWith(color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
