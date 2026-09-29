import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/authentication/pages/Welcome_page.dart';

class CpemsApp extends StatelessWidget {
  const CpemsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPEMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WelcomePage()
    );
  }
}