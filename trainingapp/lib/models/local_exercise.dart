import 'package:hive/hive.dart';

part 'local_exercise.g.dart';

@HiveType(typeId: 3)
class LocalExercise {
  @HiveField(0)
  String name;

  @HiveField(1)
  String muscleGroup;

  @HiveField(2)
  bool isCustom; // true if user-created, false if preset

  LocalExercise({
    required this.name,
    required this.muscleGroup,
    this.isCustom = false,
  });
}
