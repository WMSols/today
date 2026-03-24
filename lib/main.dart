import 'package:flutter/widgets.dart';

import 'package:today/app/app.dart';
import 'package:today/core/init/app_initializer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.init();
  runApp(const TodayApp());
}
