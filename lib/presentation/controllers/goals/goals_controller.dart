import 'package:get/get.dart';

class GoalsController extends GetxController {
  final RxString primaryGoal = ''.obs;

  void updatePrimaryGoal(String value) {
    primaryGoal.value = value;
  }
}
