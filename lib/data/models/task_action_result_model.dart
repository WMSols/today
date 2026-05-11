import 'package:today/domain/entities/task_action_result_entity.dart';

class TaskActionResultModel extends TaskActionResultEntity {
  const TaskActionResultModel({
    required super.ok,
    super.already,
    super.earned,
    super.cost,
    super.balance,
  });

  factory TaskActionResultModel.fromJson(Map<String, dynamic> json) {
    return TaskActionResultModel(
      ok: json['ok'] == true,
      already: json['already'] == true,
      earned: (json['earned'] as num?)?.toInt(),
      cost: (json['cost'] as num?)?.toInt(),
      balance: (json['balance'] as num?)?.toInt(),
    );
  }
}

