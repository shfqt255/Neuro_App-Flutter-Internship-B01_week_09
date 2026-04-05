import 'package:flutter/material.dart';
import 'package:modals_app/home.dart';

void main() => runApp(const ModalsApp());

class ModalsApp extends StatelessWidget {
  const ModalsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C63FF)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
