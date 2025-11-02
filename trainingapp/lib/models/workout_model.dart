import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'workout_model.g.dart';

@HiveType(typeId: 0)
class WorkoutSet {
  @HiveField(0)
  int setNumber;

  @HiveField(1)
  int reps;

  @HiveField(2)
  double weight;

  WorkoutSet({
    required this.setNumber,
    required this.reps,
    this.weight = 0.0,
  });
}

@HiveType(typeId: 1)
class Exercise {
  @HiveField(0)
  String exerciseName;

  @HiveField(1)
  String muscleGroup;

  @HiveField(2)
  List<WorkoutSet> sets;

  Exercise({
    required this.exerciseName,
    required this.muscleGroup,
  }) : sets = [];
}

@HiveType(typeId: 2)
class Workout {
  @HiveField(0)
  String id;

  @HiveField(1)
  String workoutName;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String time;

  @HiveField(4)
  List<String> weather;

  @HiveField(5)
  List<Exercise> exercises;

  @HiveField(6)
  bool isFinished;

  Workout({
    required this.workoutName,
    required this.date,
    required this.time,
    required this.weather,
    required this.exercises,
    this.isFinished = false,
  }) : id = Uuid().v4(); // generate unique ID

  String? get workoutDate {
    return '${date.year}-${date.month}-${date.day}';
  }
}
