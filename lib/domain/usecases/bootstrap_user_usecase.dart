import 'package:today/domain/entities/auth_bootstrap_entity.dart';
import 'package:today/domain/repositories/auth_repository.dart';

class BootstrapUserUseCase {
  const BootstrapUserUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthBootstrapEntity> call({bool rememberMe = true}) {
    return _repository.bootstrapUser(rememberMe: rememberMe);
  }
}
