import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

class CpemsApp extends StatelessWidget {
  const CpemsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPEMS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CPEMS'),
        ),
        body: const Center(
          child: Text('CPEMS Mobile Application'),
        ),
      ),
    );
  }
}