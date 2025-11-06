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
  String duration; // Duration in seconds

  @HiveField(4)
  List<Exercise> exercises;

  @HiveField(5)
  bool isFinished;

  Workout({
    required this.workoutName,
    required this.date,
    this.duration = "0",
    required this.exercises,
    this.isFinished = false,
  }) : id = Uuid().v4(); // generate unique ID

  String? get workoutDate {
    return '${date.year}-${date.month}-${date.day}';
  }

  // Format duration for display
  String get formattedDuration {
    final seconds = int.tryParse(duration) ?? 0;
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${secs}s';
    } else {
      return '${secs}s';
    }
  }

  // Get total sets
  int get totalSets {
    return exercises.fold(0, (sum, ex) => sum + ex.sets.length);
  }

  // Get total volume (sets × reps × weight)
  double get totalVolume {
    return exercises.fold(0.0, (sum, ex) {
      return sum + ex.sets.fold(0.0, (exSum, set) {
        return exSum + (set.reps * set.weight);
      });
    });
  }
}
