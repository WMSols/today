import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:today/app/app.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';

void main() {
  testWidgets('app starts and shows onboarding scaffold', (tester) async {
    await tester.pumpWidget(const TodayApp());
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text(AppTexts.getStarted), findsOneWidget);
    Get.reset();
  });
}
