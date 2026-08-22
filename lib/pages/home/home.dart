import 'package:flutter/material.dart';
import '../../features/main/main_nav_scaffold.dart';

export '../../features/main/main_nav_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainNavScaffold();
  }
}
