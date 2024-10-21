import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/screens/finished_workout.dart';
import 'package:trainingapp/screens/ongoing_workout.dart';
import 'screens/home.dart';
import 'components/bottom_appbar.dart';
import 'states/screen_index_provider.dart';
import 'screens/history.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ScreenIndexProvider(),
    child: trainingApp(),
  ));
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
