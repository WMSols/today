import 'package:get/get.dart';
import 'package:today/domain/entities/goal_card_entity.dart';
import 'package:today/domain/usecases/get_goal_cards_usecase.dart';

class GoalsController extends GetxController {
  GoalsController(this._getGoalCardsUseCase);

  final GetGoalCardsUseCase _getGoalCardsUseCase;

  final RxBool showEmptyGoal = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<GoalCardEntity> goalCards = <GoalCardEntity>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await loadGoalCards();
  }

  Future<void> loadGoalCards() async {
    isLoading.value = true;
    try {
      final items = await _getGoalCardsUseCase();
      goalCards.assignAll(items);
    } finally {
      isLoading.value = false;
    }
  }

  void openEmptyGoal() {
    showEmptyGoal.value = true;
  }
}
