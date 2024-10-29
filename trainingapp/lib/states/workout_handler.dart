import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:trainingapp/models/workout_model.dart';

class WorkoutProvider extends ChangeNotifier {
  List<Workout> _workouts = [];
  String _userBodyWeight = "87";
  String _userName = "";
  List<DateTime> _trainingDays = [];

  // Getter för alla workouts
  List<Workout> get workouts => _workouts;
  String get userBodyWeight => _userBodyWeight;
  String get userName => _userName;
  List get trainingDays => _trainingDays;

  Workout? get latestWorkout {
    if (_workouts.isNotEmpty) {
      return _workouts.last;
    }
    return null;
  }

  // Lägg till en ny workout
  void addWorkout() {
    print('KOMMER VI HIT?');
    if (_workouts.isEmpty || workouts.last.isFinished) {
      _workouts.add(
        Workout(
            workoutName: 'Workout of the day',
            date: DateTime.now(), // Datum sätts till nuvarande tid
            time: '00:00:00',
            weather: ['?', 'Not found'],
            exercises: []),
      );
    }
    // notifyListeners();
  }

  Workout getWorkoutById(String id) {
    return _workouts.firstWhere((workout) => workout.id == id);
  }

  // Lägg till en ny exercise till en specifik workout
  void addExerciseToWorkout(
      String workoutId, String exerciseName, String muscleGroup) {
    Workout workout = getWorkoutById(workoutId);
    workout.exercises.add(
      Exercise(exerciseName: exerciseName, muscleGroup: muscleGroup),
    );
    addSetToExercise(workoutId, workouts.last.exercises.length - 1, 1, 1);
    notifyListeners();
  }

  void addSetToExercise(
      String workoutId, int exerciseIndex, int reps, double weight) {
    Workout workout = getWorkoutById(workoutId);
    int nextSetNumber = workout.exercises[exerciseIndex].sets.length + 1;
    workout.exercises[exerciseIndex].sets.add(
      WorkoutSet(setNumber: nextSetNumber, reps: reps, weight: weight),
    );
    notifyListeners();
  }

  void updateSetList() {
    notifyListeners();
  }

  // Uppdatera ett specifikt set
  void updateSet(String workoutId, int exerciseIndex, int setIndex, int reps,
      double weight) {
    Workout workout = getWorkoutById(workoutId);
    workout.exercises[exerciseIndex].sets[setIndex].reps = reps;
    workout.exercises[exerciseIndex].sets[setIndex].weight = weight;
    // notifyListeners();
  }

  void updateWorkoutStatus(String workoutID) {
    Workout workoutToBeChanged = getWorkoutById(workoutID);
    workoutToBeChanged.isFinished = true;
    notifyListeners();
  }

  void setWorkoutName(String workoutName, String workoutID) {
    Workout workoutToBeChanged = getWorkoutById(workoutID);
    workoutToBeChanged.workoutName = workoutName;
    notifyListeners();
  }

  void setWorkoutTime(String workoutTime, String workoutID) {
    Workout workoutToBeChanged = getWorkoutById(workoutID);
    workoutToBeChanged.time = workoutTime;
    notifyListeners();
  }

  void setWorkoutWeather(List<String> workoutWeather, String workoutID) {
    Workout workoutToBeChanged = getWorkoutById(workoutID);
    workoutToBeChanged.weather = workoutWeather;
    notifyListeners();
  }

  void setUserWeight(String weight) {
    _userBodyWeight = weight;
    notifyListeners();
  }

  void setUserName(newUsername) {
    _userName = newUsername;
    notifyListeners();
  }

  void addTrainingDay(DateTime date) {
    trainingDays.add(date);
    notifyListeners();
  }
}
