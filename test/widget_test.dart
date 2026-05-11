import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:today/app/app.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/presentation/controllers/theme/theme_controller.dart';

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
  });

  tearDown(Get.reset);

  testWidgets('app starts and shows onboarding scaffold', (tester) async {
    await tester.pumpWidget(const TodayApp());
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text(AppTexts.getStarted), findsOneWidget);
  });
}
