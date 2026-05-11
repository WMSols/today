import 'package:today/domain/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthResultEntity> call({
    required String username,
    required String password,
    bool rememberMe = true,
  }) {
    return _repository.login(
      username: username,
      password: password,
      rememberMe: rememberMe,
    );
  }
}

