import 'package:flutter/material.dart';
import 'screens/home.dart';

void main() {
  runApp(trainingApp());
}

class trainingApp extends StatelessWidget {
  const trainingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: homePage(),
    );
  }
}
