import 'package:today/domain/repositories/auth_repository.dart';

class SignupUseCase {
  const SignupUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthResultEntity> call({
    required String username,
    required String password,
    String? timezone,
    bool autoLogin = false,
  }) {
    return _repository.signup(
      username: username,
      password: password,
      timezone: timezone,
      autoLogin: autoLogin,
    );
  }
}
