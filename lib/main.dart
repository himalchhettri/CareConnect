import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'splash_page.dart';

void main() {
  runApp(const CareConnectApp());
}

class CareConnectApp extends StatelessWidget {
  const CareConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CareConnect',
      theme: AppTheme.theme,
      home: const SplashPage(),
    );
  }
}