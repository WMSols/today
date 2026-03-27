import 'package:today/domain/entities/goal_card_entity.dart';
import 'package:today/domain/repositories/active_goal_repository.dart';

class GetGoalCardsUseCase {
  const GetGoalCardsUseCase(this._repository);

  final ActiveGoalRepository _repository;

  Future<List<GoalCardEntity>> call() {
    return _repository.getGoalCards();
  }
}
