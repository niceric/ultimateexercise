import 'package:flutter/material.dart';
import 'package:trainingapp/models/weather_model.dart';
import 'package:trainingapp/states/weather_handler.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:trainingapp/components/exercise_tile.dart';
import '../services/weather_service.dart';

class CreateWorkout extends StatelessWidget {
  CreateWorkout({super.key});

  final controller = TextEditingController();
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
      context.read<WorkoutProvider>().addWorkout();
      //
      return Scaffold(
        appBar: AppBar(
          title: Text('Create Workout'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Card(
                color: Colors.lightBlue[50],
                elevation: 4,
                margin: EdgeInsets.all(8.0),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: controller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText:
                                    workoutProvider.workouts.last.workoutName ==
                                            'Workout of the day'
                                        ? 'The name of the workout'
                                        : workoutProvider
                                            .workouts.last.workoutName),
                            onChanged: (value) => {
                              context.read<WorkoutProvider>().setWorkoutName(
                                  controller.text,
                                  workoutProvider.workouts.last.id)
                            },
                          ),
                        ]))),
            Expanded(
              child: workoutProvider.workouts.isEmpty ||
                      workoutProvider.workouts.last.exercises.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.fitness_center,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No exercises added yet',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tap the + button below to add exercises',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: workoutProvider.workouts.last.exercises.length,
                      itemBuilder: (context, index) {
                        return ExerciseTile(
                          workoutID: workoutProvider.workouts.last.id,
                          exerciseIndex: index,
                          workoutStatus: 1,
                        );
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Add Exercise Button
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Add Exercise'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () => context.go('/add_exercise'),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Start Workout Button
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.play_arrow),
                      label: Text('Start Workout'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: workoutProvider.workouts.isEmpty ||
                              workoutProvider.workouts.last.exercises.isEmpty
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
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
