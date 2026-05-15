import 'package:get/get.dart';
import 'package:flutter/widgets.dart';

import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/presentation/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final RxInt currentPage = 0.obs;
  late final PageController pageController;

  String get primaryActionLabel =>
      currentPage.value == 0 ? AppTexts.getStarted : AppTexts.continueWithEmail;

  bool get showSocialButtons => currentPage.value == 1;

  String? get legalText =>
      currentPage.value == 0 ? AppTexts.onboardingTerms : null;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  void setPage(int index) {
    currentPage.value = index;
  }

  Future<void> nextPage() async {
    if (currentPage.value >= 1) return;
    await pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void onPrimaryAction() {
    if (currentPage.value == 0) {
      nextPage();
    } else {
      goToAuth();
    }
  }

  void goToAuth() {
    Get.toNamed<void>(AppRoutes.auth);
  }

  void goToPlanner() {
    Get.offAllNamed<void>(AppRoutes.planner);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
