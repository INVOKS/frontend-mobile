import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const InvoksApp());
}

class InvoksApp extends StatelessWidget {
  const InvoksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INVOKS',
      theme: AppTheme.light,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
