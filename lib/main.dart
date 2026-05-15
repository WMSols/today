import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';

import 'package:today/app/app.dart';
import 'package:today/presentation/controllers/settings/theme_controller.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // ThemeController registered here so [TodayApp] can build; prefs load on splash.
  Get.put<ThemeController>(ThemeController(), permanent: true);
  runApp(const TodayApp());
}
