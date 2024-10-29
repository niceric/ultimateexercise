import 'package:uuid/uuid.dart';

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
  }) : id = Uuid().v4(); // generete unique ID

  String? get workoutDate {
    return '${date.year}-${date.month}-${date.day}';
  }
}
