import 'package:get/get.dart';
import 'package:today/core/network/zen_quote_service.dart';
import 'package:today/domain/entities/goal_card_entity.dart';
import 'package:today/presentation/controllers/goals/goal_cards_controller.dart';

class GoalsController extends GetxController {
  GoalsController(this._goalCardsController);

  final GoalCardsController _goalCardsController;

  final RxBool showEmptyGoal = false.obs;
  final Rxn<({String quote, String author})> dailyQuote = Rxn();
  final RxBool isDailyQuoteLoading = false.obs;

  bool _dailyQuoteRequested = false;

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

  int get goalsTotalCount => goalCards.length;

  double get goalsAggregateProgress {
    if (goalCards.isEmpty) return 0;
    var sum = 0.0;
    for (final goal in goalCards) {
      sum += goal.progress;
    }
    return (sum / goalCards.length).clamp(0.0, 1.0);
  }

  int get goalsCompletedTasksCount {
    var total = 0;
    for (final goal in goalCards) {
      final match = RegExp(r'(\d+)\s*/\s*(\d+)').firstMatch(goal.tasksText);
      if (match != null) {
        total += int.tryParse(match.group(1)!) ?? 0;
      }
    }
    return total;
  }

  void ensureDailyQuoteLoaded() {
    if (_dailyQuoteRequested) return;
    _dailyQuoteRequested = true;
    isDailyQuoteLoading.value = true;
    const ZenQuoteService()
        .fetchTodayQuote()
        .then((quote) {
          dailyQuote.value = quote;
        })
        .whenComplete(() {
          isDailyQuoteLoading.value = false;
        });
  }

  void openEmptyGoal() {
    showEmptyGoal.value = true;
  }
}
