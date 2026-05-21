import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:today/core/init/app_system_ui.dart';
import 'package:today/core/theme/app_theme.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/presentation/bindings/main/initial_binding.dart';
import 'package:today/presentation/controllers/settings/accent_color_controller.dart';
import 'package:today/presentation/controllers/settings/theme_controller.dart';
import 'package:today/presentation/routes/app_pages.dart';
import 'package:today/presentation/routes/app_routes.dart';

class TodayApp extends StatelessWidget {
  const TodayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (theme) => GetBuilder<AccentColorController>(
        builder: (accent) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppTexts.appName,
          initialBinding: InitialBinding(),
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
          theme: AppTheme.light(accent.accent),
          darkTheme: AppTheme.dark(accent.accent),
          themeMode: theme.themeMode,
          builder: (context, child) {
            final brightness = Theme.of(context).brightness;
            final surface = brightness == Brightness.dark
                ? AppColors.black
                : AppColors.white;

            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: AppSystemUi.overlayFor(brightness),
              child: ColoredBox(
                color: surface,
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
        ),
      ),
    );
  }
}
