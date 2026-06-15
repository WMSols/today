import 'package:today/domain/entities/auth_config_entity.dart';
import 'package:today/domain/repositories/auth_repository.dart';

class GetAuthConfigUseCase {
  const GetAuthConfigUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthConfigEntity> call() => _repository.getAuthConfig();
}
