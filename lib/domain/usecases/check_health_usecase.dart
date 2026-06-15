import 'package:today/domain/entities/health_status_entity.dart';
import 'package:today/domain/repositories/auth_repository.dart';

class CheckHealthUseCase {
  const CheckHealthUseCase(this._repository);

  final AuthRepository _repository;

  Future<HealthStatusEntity> call() => _repository.checkHealth();
}
