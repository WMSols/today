import 'package:get/get.dart';
import 'package:flutter/widgets.dart';

class OnboardingController extends GetxController {
  final RxInt currentPage = 0.obs;
  late final PageController pageController;

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

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
