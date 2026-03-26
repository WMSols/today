import 'package:get/get.dart';

import 'package:today/core/network/connectivity_service.dart';
import 'package:today/core/network/dio_client.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    DioClient.instanceWith();
    Get.put<ConnectivityService>(ConnectivityService(), permanent: true);
  }
}
