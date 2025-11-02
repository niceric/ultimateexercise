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
import 'package:trainingapp/states/stopwatch-handler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trainingapp/models/workout_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters for custom types
  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(WorkoutSetAdapter());

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
        ChangeNotifierProvider(create: (context) => WorkoutProvider()),
        ChangeNotifierProvider(create: (context) => StopwatchProvider())
      ],
      child: trainingApp(),
    ),
  );
}

class trainingApp extends StatelessWidget {
  const trainingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: ScreenIndexProvider().fetchRouter);
  }
}
