import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt selectedTabIndex = 0.obs;

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }
}
