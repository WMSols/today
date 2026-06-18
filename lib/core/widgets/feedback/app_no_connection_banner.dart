import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:today/core/network/connectivity_service.dart';
import 'package:today/core/theme/app_toast_colors.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/core/widgets/feedback/app_toast.dart';

/// Wraps [child] and shows a bottom banner when the device has no internet.
class AppNoConnectionBanner extends StatelessWidget {
  const AppNoConnectionBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ConnectivityService>()) {
      return child;
    }

    final connectivity = Get.find<ConnectivityService>();
    return Obx(() {
      final isOffline = !connectivity.isOnline.value;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          if (isOffline)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppToastBar(
                message: AppTexts.noInternet,
                style: AppToastStyle.neutral,
              ),
            ),
        ],
      );
    });
  }
}
