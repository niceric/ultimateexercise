import 'package:flutter/material.dart';
import 'package:trainingapp/components/workout.dart';

class WorkoutHandler extends ChangeNotifier {
  List<Workout> _workouts = [];

  List<Workout> get currentWorkouts {
    return _workouts;
  }

  addWorkout(String workoutName, String currentWeather, int weight, int time,
      int date, String exercise, int reps, int sets) {
    _workouts.add(Workout(
        workoutName: workoutName,
        currentWeather: currentWeather,
        weight: weight,
        time: time,
        date: date,
        exercise: exercise,
        reps: reps,
        sets: sets));
  }

  void printWorkouts() {
    print(_workouts);
  }
}
