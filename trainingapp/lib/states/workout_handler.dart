import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:trainingapp/models/workout_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// class WorkoutProvider extends ChangeNotifier {
//   List<Workout> _workouts = [];

//   List<Workout> get workouts {
//     return _workouts;
//   }

//   void addWorkout(String workoutName) {
//     _workouts.add(Workout(
//         workoutName: workoutName,
//         sets: [])); // Lägger till en workout utan sets
//     notifyListeners();
//   }

//   // void addWorkout(String exerciseName, String workoutName) {
//   //   _workouts.add(Workout(

//   //       workoutName: workoutName,
//   //       sets: [WorkoutSet(exerciseName: exerciseName, setNumber: 1)]));
//   //   notifyListeners();
//   // }
//   // Lägg till en exercise till en specifik workout
//   void addExerciseToWorkout(int workoutIndex, String exerciseName) {
//     int nextSetNumber = _workouts[workoutIndex].sets.length + 1;
//     _workouts[workoutIndex].sets.add(
//           WorkoutSet(exerciseName: exerciseName, setNumber: nextSetNumber),
//         );
//     notifyListeners();
//   }

//   void addSetToWorkout(int workoutIndex) {
//     int nextSetNumber = _workouts[workoutIndex].sets.length + 1;
//     _workouts[workoutIndex]
//         .sets
//         .add(WorkoutSet(exerciseName: 'xerciseName', setNumber: nextSetNumber));
//     notifyListeners();
//   }

//   void updateSet(int workoutIndex, int setIndex, double weight, int reps) {
//     _workouts[workoutIndex].sets[setIndex].weight = weight;
//     _workouts[workoutIndex].sets[setIndex].reps = reps;
//   }

//   // void printWorkouts() {
//   //   print(_workouts);
//   // }
// }

/////////////////
///
///

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

  WorkoutProvider() {
    setWorkouts();
  }

  WorkoutProvider() {
    setWorkouts();
  }

  Workout? get latestWorkout {
    if (_workouts.isNotEmpty) {
      return _workouts.last; // Hämta den senaste workouten
    }
    return null; // Returnera null om listan är tom
  }

  void setWorkouts() async {
    _workouts = await getWorkoutList();
  }

  Future<void> saveWorkoutList(List<Workout> workouts) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonStringList =
        workouts.map((workout) => jsonEncode(workout.toJson())).toList();
    await prefs.setStringList('workout_list', jsonStringList);
  }

  Future<List<Workout>> getWorkoutList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonStringList = prefs.getStringList('workout_list');

    if (jsonStringList != null) {
      return jsonStringList
          .map((jsonString) => Workout.fromJson(jsonDecode(jsonString), this))
          .toList();
    }
    notifyListeners();
    return [];
  }

  String? getLatestExerciseName() {
    final latestWorkout = _workouts.last; // Hämta senaste workout
    if (_workouts.isNotEmpty && latestWorkout.exercises.isNotEmpty) {
      return latestWorkout.exercises.last.exerciseName;

      // Hämta namnet på senaste övningen
    }

    return null; // Returnera null om ingen övning finns
  }

  // Lägg till en ny workout
  void addWorkout(String workoutName, String time, String weather) {
    print('KOMMER VI HIT?');
    if (_workouts.isEmpty || workouts.last.isFinished) {
      _workouts.add(
        Workout(
            workoutName: workoutName,
            date: DateTime.now(), // Datum sätts till nuvarande tid
            time: '00:00:00',
            weather: [],
            exercises: []),
      );
    }
    // notifyListeners();
  }

  // Hämta en workout genom att använda dess ID
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

    notifyListeners();
  }

  // Lägg till ett set till en specifik exercise i en workout
  // void addSetToExercise(
  //     String workoutId, int exerciseIndex, int reps, double weight) {
  //   Workout workout = getWorkoutById(workoutId);
  //   int nextSetNumber = workout.exercises[exerciseIndex].sets.length + 1;
  //   workout.exercises[exerciseIndex].sets.add(
  //     WorkoutSet(setNumber: nextSetNumber, reps: reps, weight: weight),
  //   );
  //   notifyListeners();
  // }

  void addSetToExercise(
      String workoutId, int exerciseIndex, int reps, double weight) {
    Workout workout = getWorkoutById(workoutId);
    int nextSetNumber = workout.exercises[exerciseIndex].sets.length + 1;
    workout.exercises[exerciseIndex].sets.add(
      WorkoutSet(setNumber: nextSetNumber, reps: reps, weight: weight),
    );
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

    saveWorkoutList(workouts);
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
