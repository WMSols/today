import 'package:get/get.dart';
import 'package:today/domain/entities/goal_card_entity.dart';
import 'package:today/presentation/controllers/goals/goal_cards_controller.dart';

class GoalsController extends GetxController {
  GoalsController(this._goalCardsController);

  final GoalCardsController _goalCardsController;

  final RxBool showEmptyGoal = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (goalCards.isEmpty && !isLoading.value) {
      loadGoalCards();
    }
  }

  RxBool get isLoading => _goalCardsController.isLoading;

  RxList<GoalCardEntity> get goalCards => _goalCardsController.goalCards;

  Future<bool> loadGoalCards() => _goalCardsController.loadGoalCards();

  void openEmptyGoal() {
    showEmptyGoal.value = true;
  }
}
