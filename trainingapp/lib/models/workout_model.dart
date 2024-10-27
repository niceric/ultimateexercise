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
}
