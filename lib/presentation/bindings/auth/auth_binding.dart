import 'package:get/get.dart';
import 'package:today/core/auth/firebase_auth_gateway.dart';
import 'package:today/domain/repositories/auth_repository.dart';
import 'package:today/presentation/controllers/auth/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(
        Get.find<AuthRepository>(),
        Get.find<FirebaseAuthGateway>(),
      ),
    );
  }
}
