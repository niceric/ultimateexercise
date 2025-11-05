import 'package:flutter/material.dart';
import 'package:trainingapp/models/weather_model.dart';
import 'package:trainingapp/states/weather_handler.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:trainingapp/components/exercise_tile.dart';
import 'package:trainingapp/components/animated_widgets.dart';
import 'package:trainingapp/theme/app_theme.dart';
import '../services/weather_service.dart';

class CreateWorkout extends StatelessWidget {
  CreateWorkout({super.key});

  final controller = TextEditingController();
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Consumer<WorkoutProvider>(builder: (context, workoutProvider, child) {
      context.read<WorkoutProvider>().addWorkout();

      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: FadeInAnimation(
            child: Text('Create Workout'),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: AnimatedGradientContainer(
          child: SafeArea(
            child: Column(
              children: [
                // Workout Name Card
                FadeInAnimation(
                  delay: Duration(milliseconds: 100),
                  child: GradientCard(
                    gradient: AppTheme.purpleGradient,
                    margin: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.edit_note,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: controller,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: workoutProvider.workouts.last.workoutName ==
                                          'Workout of the day'
                                      ? 'Name your workout...'
                                      : workoutProvider.workouts.last.workoutName,
                                  hintStyle: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  filled: false,
                                ),
                                onChanged: (value) => {
                                  context.read<WorkoutProvider>().setWorkoutName(
                                      controller.text,
                                      workoutProvider.workouts.last.id)
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Exercises List
                Expanded(
                  child: workoutProvider.workouts.isEmpty ||
                          workoutProvider.workouts.last.exercises.isEmpty
                      ? FadeInAnimation(
                          delay: Duration(milliseconds: 300),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ScaleAnimation(
                                  duration: Duration(milliseconds: 600),
                                  child: Container(
                                    padding: EdgeInsets.all(32),
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceDark,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppTheme.accentPurple
                                              .withOpacity(0.3),
                                          blurRadius: 30,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.fitness_center,
                                      size: 80,
                                      color: AppTheme.accentPurple,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 32),
                                FadeInAnimation(
                                  delay: Duration(milliseconds: 400),
                                  child: Text(
                                    'No exercises added yet',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                FadeInAnimation(
                                  delay: Duration(milliseconds: 500),
                                  child: Text(
                                    'Tap the button below to get started',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 24),
                                FadeInAnimation(
                                  delay: Duration(milliseconds: 600),
                                  child: Icon(
                                    Icons.arrow_downward,
                                    color: AppTheme.accentCyan,
                                    size: 32,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: workoutProvider.workouts.last.exercises.length,
                          itemBuilder: (context, index) {
                            return FadeInAnimation(
                              delay: Duration(milliseconds: 100 * index),
                              child: ExerciseTile(
                                workoutID: workoutProvider.workouts.last.id,
                                exerciseIndex: index,
                                workoutStatus: 1,
                              ),
                            );
                          },
                        ),
                ),

                // Bottom Buttons
                FadeInAnimation(
                  delay: Duration(milliseconds: 200),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryDark,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Add Exercise Button
                        Expanded(
                          child: ScaleAnimation(
                            delay: Duration(milliseconds: 400),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: AppTheme.cyanGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.accentCyan.withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () => context.go('/add_exercise'),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 18),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_circle_outline,
                                            color: Colors.white),
                                        SizedBox(width: 8),
                                        Text(
                                          'Add Exercise',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),

                        // Start Workout Button
                        Expanded(
                          child: ScaleAnimation(
                            delay: Duration(milliseconds: 500),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: workoutProvider.workouts.isEmpty ||
                                        workoutProvider
                                            .workouts.last.exercises.isEmpty
                                    ? LinearGradient(
                                        colors: [Colors.grey, Colors.grey])
                                    : AppTheme.greenGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: workoutProvider.workouts.isEmpty ||
                                        workoutProvider
                                            .workouts.last.exercises.isEmpty
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: AppTheme.accentGreen
                                              .withOpacity(0.4),
                                          blurRadius: 15,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: workoutProvider.workouts.isEmpty ||
                                          workoutProvider
                                              .workouts.last.exercises.isEmpty
                                      ? null
                                      : () async {
                                          // Fetch weather first (await it to complete)
                                          await weatherProvider.fetchWeather();

                                          // Set weather data (with fallback if null)
                                          final weather = weatherProvider.weather;
                                          if (weather != null) {
                                            workoutProvider.setWorkoutWeather([
                                              '${weather.temperatureCelsius.round()}',
                                              weather.mainCondition,
                                            ], workoutProvider.workouts.last.id);
                                          } else {
                                            // Fallback if weather fetch failed
                                            workoutProvider.setWorkoutWeather([
                                              '?',
                                              'Not found'
                                            ], workoutProvider.workouts.last.id);
                                          }

                                          // Navigate to ongoing workout
                                          context.go('/ongoing_workout');
                                        },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 18),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.play_arrow,
                                            color: Colors.white),
                                        SizedBox(width: 8),
                                        Text(
                                          'Start Workout',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
