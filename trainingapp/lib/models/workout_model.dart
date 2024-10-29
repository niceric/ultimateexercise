// class WorkoutSet {
//   String exerciseName;
//   int setNumber;
//   double weight;
//   int reps;

//   WorkoutSet({
//     required this.exerciseName,
//     required this.setNumber,
//     this.weight = 0.0,
//     this.reps = 0,
//   });
// }

// class Workout {
//   String workoutName = '';
//   List<WorkoutSet> sets;

//   Workout({
//     required this.workoutName,
//     required this.sets,
//   });

//   String get getWorkoutName => workoutName;
// }
import 'dart:ffi';

import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/models/exercise_model.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:uuid/uuid.dart'; // Används för att skapa unika ID:n

class WorkoutSet {
  int setNumber;
  int reps;
  double weight;

  WorkoutSet({
    required this.setNumber,
    required this.reps,
    this.weight = 0.0,
  });
}

class Exercise {
  String exerciseName;
  String muscleGroup;
  List<WorkoutSet> sets;

  Exercise({
    required this.exerciseName,
    required this.muscleGroup,
  }) : sets = [];

  // Map<String, dynamic> toJson() {
  //   //not used atm
  //   return {
  //     'exerciseName': exerciseName,
  //     'muscleGroup': muscleGroup,
  //     'sets': sets,
  //   };
  // }

  // List<WorkoutSet> get getSets {
  //   return sets;
  // }

  // List<int> get getReps {
  //   List<int> repStrings = [];
  //   for (var i = 0; i < sets.length; i++) {
  //     repStrings.add(sets[i].reps);
  //   }
  //   return repStrings;
  // }

  // List<double> get getWeights {
  //   List<double> weightStrings = [];
  //   for (var i = 0; i < sets.length; i++) {
  //     weightStrings.add(sets[i].weight);
  //   }
  //   return weightStrings;
  // }
}

class Workout {
  String id;
  String workoutName;
  DateTime date;
  String time;
  List<String> weather;
  List<Exercise> exercises;
  bool isFinished;

  Workout({
    required this.workoutName,
    required this.date,
    required this.time,
    required this.weather,
    required this.exercises,
    this.isFinished = false,
  }) : id = Uuid().v4(); // Generera ett unikt ID

  String? get workoutDate {
    return '${date.year}-${date.month}-${date.day}';
  }

  factory Workout.fromJson(
      //utkommenterad kod är till för att få fram reps/weight
      //koden är kvar för att visa att det blir för svårt att få fram reps/weight med vår kodstruktur genom
      //shared preferences, hade hive användts hade det nog varit lättare då det verkar som man kan spara
      //objekt som dem är, dvs inte behöva bryta ner workouts i bestånds delar för att kunna spara.
      Map<String, dynamic> json,
      WorkoutProvider provider) {
    var array = json['weather'];
    List<String> weatherStrings = List<String>.from(array);
    List<Exercise> exerciseList = [];

    for (var i = 0; i < int.parse(json['exercises']); i++) {
      //lägger till varje exercisename och musclegroup i den rätta excersicesen för att sedan kunna skapa
      //nya, dvs den gör nya kopior istället för att "spara" excersices.
      exerciseList.add(Exercise(
          //lägger till exercises i exericse list
          exerciseName: json['exercisesnames'][i].toString(),
          muscleGroup: json['muscleGroup'][i].toString()));
      // for (var y = 0; y < int.parse(json['sets']); y++) {
      //   provider.addSetToExercise(json['id'], i, int.parse(json['reps'][y]),
      //       double.parse(json['weights'][y]));
      // }
    }
    return Workout(
      workoutName: json['workoutName'],
      date: DateTime(
          int.parse(json['dateyear']),
          int.parse(json['datemonth']),
          int.parse(json[
              'dateday'])), //gör om 3 strings till 3 ints för att skapa nua datetimes
      time: json['time'],
      weather: weatherStrings,
      exercises: exerciseList,
    );
  }

  Map<String, dynamic> toJson() {
    List<String> exerciseNames = [];
    List<String> muscleGroups = [];
    List<String> sets = [];
    // List<int> reps = [];
    // List<double> weights = [];
    for (var i = 0; i < exercises.length; i++) {
      exerciseNames.add(exercises[i].exerciseName);
      muscleGroups.add(exercises[i].muscleGroup);
      // sets.add(exercises[i].getSets.toString());
      // for (var y = 0; y < sets.length; y++) {
      //   reps.add(exercises[i].getReps[y]);
      //   weights.add(exercises[i].getWeights[y]);
      // }
    }

    return {
      'id': id,
      'workoutName': workoutName,
      'dateyear': date.year
          .toString(), //bryter ut datetime till 3 strings itället för datetime formatet
      'datemonth': date.hour.toString(),
      'dateday': date.day.toString(),
      'time': time,
      'weather': weather,
      'exercises': exercises.length.toString(),
      'exercisesnames': exerciseNames,
      'muscleGroup': muscleGroups,
      // 'sets': sets.length.toString(),
      // 'reps': reps,
      // 'weights': weights,
    };
  }
}
