import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:today/core/storage/initial_plan_storage.dart';
import 'package:today/core/utils/app_texts/app_texts.dart';
import 'package:today/presentation/controllers/auth/auth_controller.dart';
import 'package:today/presentation/routes/app_routes.dart';

class OnboardingController extends GetxController {
  OnboardingController(this._storage);

  final InitialPlanStorage _storage;

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
      goToCreateInitialPlan();
    }
  }

  Future<void> goToCreateInitialPlan() async {
    await _storage.setOnboardingCompleted();
    await Get.offNamed<void>(AppRoutes.createInitialPlan);
  }

  Future<void> _completeOnboardingForSocialShortcut() async {
    await _storage.setOnboardingCompleted();
    await _storage.skipInitialPlanDraft();
  }

  Future<void> onGoogleSocialTap() async {
    if (!Get.isRegistered<AuthController>()) return;
    await _completeOnboardingForSocialShortcut();
    await Get.find<AuthController>().signInWithGoogle();
  }

  Future<void> onAppleSocialTap() async {
    if (!Get.isRegistered<AuthController>()) return;
    await _completeOnboardingForSocialShortcut();
    await Get.find<AuthController>().signInWithApple();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
