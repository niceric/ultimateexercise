import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/screens/finished_workout.dart';
import 'package:trainingapp/screens/ongoing_workout.dart';
import 'screens/home.dart';
import 'components/bottom_appbar.dart';
import 'states/screen_index_provider.dart';
import 'screens/history.dart';
import 'package:go_router/go_router.dart';
import 'package:trainingapp/services/weather_service.dart';
import 'package:trainingapp/states/weather_handler.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ScreenIndexProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
              WeatherService('e9a12a2f99efdcf6750f398f097eb9b6')),
        ),
      ],
      child: trainingApp(),
    ),
  );
}

class trainingApp extends StatelessWidget {
  const trainingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: ScreenIndexProvider().fetchRouter);
  }
}
