import 'package:get/get.dart';
import 'package:today/domain/entities/goal_card_entity.dart';
import 'package:today/domain/usecases/get_goal_cards_usecase.dart';

/// Shared goal-card list state for home and goals tabs.
class GoalCardsController extends GetxController {
  GoalCardsController(this._getGoalCardsUseCase);

  final GetGoalCardsUseCase _getGoalCardsUseCase;

  final RxBool isLoading = false.obs;
  final RxList<GoalCardEntity> goalCards = <GoalCardEntity>[].obs;

  /// Returns `true` when cards were loaded successfully.
  Future<bool> loadGoalCards({bool force = false}) async {
    if (!force && goalCards.isNotEmpty) {
      return true;
    }
    if (isLoading.value) {
      return goalCards.isNotEmpty;
    }
    isLoading.value = true;
    try {
      final items = await _getGoalCardsUseCase();
      goalCards.assignAll(items);
      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
