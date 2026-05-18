import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:today/core/extensions/theme_context_extension.dart';
import 'package:today/core/init/app_system_ui.dart';
import 'package:today/core/widgets/features/splash/splash_brand_title.dart';
import 'package:today/presentation/controllers/splash/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppSystemUi.overlayFor(Theme.of(context).brightness),
      child: Scaffold(
        backgroundColor: context.surfaceColor,
        body: Center(
          child: Obx(() {
            final composition = controller.lottieComposition.value;
            return SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (composition != null)
                    Lottie(
                      composition: composition,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  const Center(child: SplashBrandTitle()),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
