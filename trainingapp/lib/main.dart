import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:trainingapp/models/workout_model.dart';
import 'package:trainingapp/models/local_exercise.dart';
import 'package:trainingapp/theme/app_theme.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:trainingapp/screens/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters for custom types
  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(WorkoutSetAdapter());
  Hive.registerAdapter(LocalExerciseAdapter());

  runApp(const TrainingApp());
}

class TrainingApp extends StatelessWidget {
  const TrainingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WorkoutProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Training App',
        theme: AppTheme.darkTheme,
        home: MainApp(),
      ),
    );
  }
}
