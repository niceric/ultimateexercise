import 'package:flutter/material.dart';
import 'package:trainingapp/models/workout_model.dart';

class WorkoutProvider extends ChangeNotifier {
  List<Workout> _workouts = [];

  List<Workout> get workouts {
    return _workouts;
  }

  void addWorkout(String exerciseName) {
    _workouts.add(
        Workout(exerciseName: exerciseName, sets: [WorkoutSet(setNumber: 1)]));
    notifyListeners();
  }

  void addSetToWorkout(int workoutIndex) {
    int nextSetNumber = _workouts[workoutIndex].sets.length + 1;
    _workouts[workoutIndex].sets.add(WorkoutSet(setNumber: nextSetNumber));
    notifyListeners();
  }

  void updateSet(int workoutIndex, int setIndex, double weight, int reps) {
    _workouts[workoutIndex].sets[setIndex].weight = weight;
    _workouts[workoutIndex].sets[setIndex].reps = reps;
    // notifyListeners();
    // debuging
    printWorkouts();
  }

  void printWorkouts() {
    print(_workouts);
  }
}
