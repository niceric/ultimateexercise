import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/screens/add_exercise.dart';
import 'package:trainingapp/screens/finished_workout.dart';
import 'package:trainingapp/screens/ongoing_workout.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'screens/home.dart';
import 'components/bottom_appbar.dart';
import 'states/screen_index_provider.dart';
import 'screens/history.dart';
import 'package:go_router/go_router.dart';
import 'package:trainingapp/services/weather_service.dart';
import 'package:trainingapp/states/weather_handler.dart';
import 'package:trainingapp/screens/add_exercise.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  //print(Directory.current.path);
  await dotenv.load(fileName: ".env");
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
        ChangeNotifierProvider(create: (context) => AddExercise()),
        ChangeNotifierProvider(create: (context) => WorkoutHandler())
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
