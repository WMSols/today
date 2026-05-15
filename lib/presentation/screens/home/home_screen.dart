import 'package:flutter/material.dart';

import 'package:today/core/widgets/common/app_page_scaffold.dart';
import 'package:today/core/widgets/features/home/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPageScaffold(child: HomeBody());
  }
}
