import 'package:get/get.dart';

class GoalInputController extends GetxController {
  final RxString goal = ''.obs;

  void updateGoal(String value) {
    goal.value = value;
  }
}
