import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:today/core/init/app_system_ui.dart';
import 'package:today/core/theme/app_theme.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/presentation/controllers/settings/theme_controller.dart';
import 'package:today/presentation/routes/app_pages.dart';
import 'package:today/presentation/routes/app_routes.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

class TodayApp extends StatelessWidget {
  const TodayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (theme) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppTexts.appName,
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: theme.themeMode,
          builder: (context, child) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final surface = isDark ? AppColors.black : AppColors.white;
            final brightness = Theme.of(context).brightness;
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: AppSystemUi.overlayFor(brightness),
              child: ColoredBox(
                color: surface,
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
        );
      },
    );
  }
}
