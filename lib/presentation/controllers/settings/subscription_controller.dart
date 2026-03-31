import 'package:get/get.dart';
import 'package:today/domain/entities/subscription_plan_entity.dart';
import 'package:today/domain/usecases/get_subscription_plans_usecase.dart';

class SubscriptionController extends GetxController {
  SubscriptionController(this._getSubscriptionPlansUseCase);

  final GetSubscriptionPlansUseCase _getSubscriptionPlansUseCase;

  final RxInt selectedPlanIndex = 1.obs;
  final RxBool isLoading = false.obs;
  final RxList<SubscriptionPlanEntity> plans = <SubscriptionPlanEntity>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadPlans();
  }

  Future<void> loadPlans() async {
    isLoading.value = true;
    try {
      final items = await _getSubscriptionPlansUseCase();
      plans.assignAll(items);
      if (selectedPlanIndex.value >= plans.length && plans.isNotEmpty) {
        selectedPlanIndex.value = 0;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void selectPlan(int index) {
    selectedPlanIndex.value = index;
  }

  SubscriptionPlanEntity? get selectedPlanOrNull {
    if (plans.isEmpty) return null;
    final index = selectedPlanIndex.value.clamp(0, plans.length - 1);
    return plans[index];
  }
}
