import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/network/connectivity_service.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_styles/app_text_styles.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

/// Wraps [child] and shows a bottom banner when the device have no internet connection.
/// Styled like YouTube's no connection banner: black background, white text, no icon.
class AppNoConnectionBanner extends StatelessWidget {
  const AppNoConnectionBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final connectivity = Get.find<ConnectivityService>();
    return Stack(
      children: [
        child,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Obx(() {
            if (connectivity.isOnline.value) return const SizedBox.shrink();
            return Container(
              width: double.infinity,
              color: AppColors.black,
              child: SafeArea(
                top: false,
                child: Center(
                  child: Text(
                    AppTexts.noInternet,
                    style: AppTextStyles.labelText(context).copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.normal,
                      decorationColor: Colors.transparent,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
