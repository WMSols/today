import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:today/core/init/app_system_ui.dart';
import 'package:today/presentation/routes/app_pages.dart';
import 'package:today/core/init/app_initializer.dart';
import 'package:today/core/utils/app_colors/app_colors.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

class TodayApp extends StatelessWidget {
  const TodayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppTexts.appName,
      initialRoute: AppInitializer.initialRoute,
      getPages: AppPages.pages,
      builder: (context, child) {
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: AppSystemUi.overlayStyle,
          child: child ?? const SizedBox.shrink(),
        );
      },
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        primaryColor: AppColors.primary,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
      ),
    );
  }
}
