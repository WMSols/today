import 'package:get/get.dart';
import 'package:today/domain/usecases/login_usecase.dart';
import 'package:today/domain/usecases/signup_usecase.dart';
import 'package:today/presentation/controllers/auth/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(Get.find<LoginUseCase>(), Get.find<SignupUseCase>()),
    );
  }
}
