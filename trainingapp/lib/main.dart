import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import 'components/bottom_appbar.dart';
import 'states/screen_index_provider.dart';

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
