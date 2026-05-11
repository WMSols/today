import 'package:today/domain/entities/me_entity.dart';
import 'package:today/domain/repositories/auth_repository.dart';

class GetMeUseCase {
  const GetMeUseCase(this._repository);

  final AuthRepository _repository;

  Future<MeEntity> call() {
    return _repository.getMe();
  }
}

