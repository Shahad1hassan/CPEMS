import 'package:flutter/material.dart';

class CpemsApp extends StatelessWidget {
  const CpemsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CPEMS',
      debugShowCheckedModeBanner: false,
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