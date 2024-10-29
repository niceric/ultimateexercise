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
              child: ListView.builder(
                itemCount: workoutProvider.workouts.isEmpty
                    ? 0
                    : workoutProvider.workouts.last.exercises.length,
                itemBuilder: (context, index) {
                  return ExerciseTile(
                    workoutID: workoutProvider.workouts.last.id,
                    exerciseIndex: index,
                    workoutStatus: 1,
                  );
                },
              ),
            ),
            Divider(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 100, right: 98),
                  child: Center(
                    child: TextButton(
                      child: Text('START WORKOUT'),
                      onPressed: () => {
                        weatherProvider.fetchWeather(),
                        workoutProvider.setWorkoutWeather([
                          '${weatherProvider.weather!.temperatureCelsius.round()}',
                          weatherProvider.weather!.mainCondition,
                        ], workoutProvider.workouts.last.id),
                        context.go('/ongoing_workout')
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => {context.go('/add_exercise')},
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
