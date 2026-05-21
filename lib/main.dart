import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import 'package:today/app/app.dart';
import 'package:today/presentation/controllers/settings/accent_color_controller.dart';
import 'package:today/presentation/controllers/settings/theme_controller.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // Required before [TodayApp] builds: GetBuilder mounts above GetMaterialApp,
  // so they run before InitialBinding runs.
  Get.put<ThemeController>(ThemeController(), permanent: true);
  Get.put<AccentColorController>(AccentColorController(), permanent: true);
  runApp(const TodayApp());
}
