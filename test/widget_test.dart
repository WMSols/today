import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/presentation/controllers/onboarding/onboarding_controller.dart';
import 'package:today/presentation/controllers/settings/theme_controller.dart';
import 'package:today/presentation/routes/app_pages.dart';
import 'package:today/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    await Get.putAsync<SharedPreferences>(
      SharedPreferences.getInstance,
      permanent: true,
    );
    Get.put<ThemeController>(ThemeController(), permanent: true);
    await Get.find<ThemeController>().loadFromStorage();
    Get.put<OnboardingController>(OnboardingController());
  });

  tearDown(Get.reset);

  testWidgets('onboarding screen shows get started CTA', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: ThemeData.light(),
        home: const OnboardingScreen(),
        getPages: AppPages.pages,
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text(AppTexts.getStarted), findsOneWidget);
  });
}
