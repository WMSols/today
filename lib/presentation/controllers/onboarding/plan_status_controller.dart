import 'dart:async';

import 'package:get/get.dart';

import 'package:today/core/navigation/post_auth_navigation.dart';
import 'package:today/core/storage/initial_plan_storage.dart';
import 'package:today/presentation/controllers/settings/haptics_controller.dart';

enum PlanStatusUiState { ready, pending }

class PlanStatusController extends GetxController {
  PlanStatusController(this._storage);

  final InitialPlanStorage _storage;

  final Rx<PlanStatusUiState> status = PlanStatusUiState.pending.obs;
  final goalPreview = Rxn<String>();
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    unawaited(_loadStatus());
  }

  Future<void> _loadStatus() async {
    isLoading.value = true;
    try {
      final pending = await _storage.getPendingGoalText();
      if (pending != null && pending.isNotEmpty) {
        status.value = PlanStatusUiState.ready;
        goalPreview.value = pending;
      } else {
        status.value = PlanStatusUiState.pending;
        goalPreview.value = null;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> continueToApp() async {
    await _completeGateAndNavigate();
  }

  Future<void> skipToApp() async {
    await _completeGateAndNavigate();
  }

  Future<void> _completeGateAndNavigate() async {
    if (Get.isRegistered<HapticsController>()) {
      Get.find<HapticsController>().impact();
    }
    await _storage.setPlanStatusGateSeen();
    await PostAuthNavigation.goAfterAuth();
  }
}
