import 'package:hive_flutter/hive_flutter.dart';
import 'package:trainingapp/models/local_exercise.dart';

class ExerciseService {
  static const String _boxName = 'custom_exercises';

  // Preset exercises organized by muscle group (100+ exercises)
  static final List<LocalExercise> _presetExercises = [
    // CHEST (15 exercises)
    LocalExercise(name: 'Bench Press', muscleGroup: 'Chest'),
    LocalExercise(name: 'Incline Bench Press', muscleGroup: 'Chest'),
    LocalExercise(name: 'Decline Bench Press', muscleGroup: 'Chest'),
    LocalExercise(name: 'Dumbbell Press', muscleGroup: 'Chest'),
    LocalExercise(name: 'Incline Dumbbell Press', muscleGroup: 'Chest'),
    LocalExercise(name: 'Dumbbell Flyes', muscleGroup: 'Chest'),
    LocalExercise(name: 'Cable Flyes', muscleGroup: 'Chest'),
    LocalExercise(name: 'Push-Ups', muscleGroup: 'Chest'),
    LocalExercise(name: 'Dips', muscleGroup: 'Chest'),
    LocalExercise(name: 'Chest Press Machine', muscleGroup: 'Chest'),
    LocalExercise(name: 'Pec Deck', muscleGroup: 'Chest'),
    LocalExercise(name: 'Cable Crossover', muscleGroup: 'Chest'),
    LocalExercise(name: 'Landmine Press', muscleGroup: 'Chest'),
    LocalExercise(name: 'Svend Press', muscleGroup: 'Chest'),
    LocalExercise(name: 'Plate Press', muscleGroup: 'Chest'),

    // BACK (18 exercises)
    LocalExercise(name: 'Deadlift', muscleGroup: 'Back'),
    LocalExercise(name: 'Pull-Ups', muscleGroup: 'Back'),
    LocalExercise(name: 'Chin-Ups', muscleGroup: 'Back'),
    LocalExercise(name: 'Bent Over Row', muscleGroup: 'Back'),
    LocalExercise(name: 'Barbell Row', muscleGroup: 'Back'),
    LocalExercise(name: 'Dumbbell Row', muscleGroup: 'Back'),
    LocalExercise(name: 'T-Bar Row', muscleGroup: 'Back'),
    LocalExercise(name: 'Seated Cable Row', muscleGroup: 'Back'),
    LocalExercise(name: 'Lat Pulldown', muscleGroup: 'Back'),
    LocalExercise(name: 'Face Pulls', muscleGroup: 'Back'),
    LocalExercise(name: 'Romanian Deadlift', muscleGroup: 'Back'),
    LocalExercise(name: 'Pendlay Row', muscleGroup: 'Back'),
    LocalExercise(name: 'Chest Supported Row', muscleGroup: 'Back'),
    LocalExercise(name: 'Single Arm Row', muscleGroup: 'Back'),
    LocalExercise(name: 'Inverted Row', muscleGroup: 'Back'),
    LocalExercise(name: 'Meadows Row', muscleGroup: 'Back'),
    LocalExercise(name: 'Rack Pulls', muscleGroup: 'Back'),
    LocalExercise(name: 'Hyperextensions', muscleGroup: 'Back'),

    // LEGS (20 exercises)
    LocalExercise(name: 'Squat', muscleGroup: 'Legs'),
    LocalExercise(name: 'Front Squat', muscleGroup: 'Legs'),
    LocalExercise(name: 'Goblet Squat', muscleGroup: 'Legs'),
    LocalExercise(name: 'Bulgarian Split Squat', muscleGroup: 'Legs'),
    LocalExercise(name: 'Leg Press', muscleGroup: 'Legs'),
    LocalExercise(name: 'Leg Extension', muscleGroup: 'Legs'),
    LocalExercise(name: 'Leg Curl', muscleGroup: 'Legs'),
    LocalExercise(name: 'Lunges', muscleGroup: 'Legs'),
    LocalExercise(name: 'Walking Lunges', muscleGroup: 'Legs'),
    LocalExercise(name: 'Reverse Lunges', muscleGroup: 'Legs'),
    LocalExercise(name: 'Step-Ups', muscleGroup: 'Legs'),
    LocalExercise(name: 'Hack Squat', muscleGroup: 'Legs'),
    LocalExercise(name: 'Sissy Squat', muscleGroup: 'Legs'),
    LocalExercise(name: 'Box Squat', muscleGroup: 'Legs'),
    LocalExercise(name: 'Sumo Squat', muscleGroup: 'Legs'),
    LocalExercise(name: 'Calf Raises', muscleGroup: 'Legs'),
    LocalExercise(name: 'Seated Calf Raises', muscleGroup: 'Legs'),
    LocalExercise(name: 'Leg Press Calf Raises', muscleGroup: 'Legs'),
    LocalExercise(name: 'Glute Bridge', muscleGroup: 'Legs'),
    LocalExercise(name: 'Hip Thrust', muscleGroup: 'Legs'),

    // SHOULDERS (15 exercises)
    LocalExercise(name: 'Overhead Press', muscleGroup: 'Shoulders'),
    LocalExercise(name: 'Military Press', muscleGroup: 'Shoulders'),
    LocalExercise(name: 'Arnold Press', muscleGroup: 'Shoulders'),
    LocalExercise(name: 'Dumbbell Shoulder Press', muscleGroup: 'Shoulders'),
    LocalExercise(name: 'Lateral Raises', muscleGroup: 'Shoulders'),
    LocalExercise(name: 'Front Raises', muscleGroup: 'Shoulders'),
    LocalExercise(name: 'Rear Delt Flyes', muscleGroup: 'Shoulders'),
    LocalExercise(name: 'Cable Lateral Raises', muscleGroup: 'Shoulders'),
    LocalExercise(name: 'Upright Row', muscleGroup: 'Shoulders'),
    LocalExercise(name: 'Shrugs', muscleGroup: 'Shoulders'),
    LocalExercise(name: 'Dumbbell Shrugs', muscleGroup: 'Shoulders'),
    LocalExercise(name: 'Face Pulls', muscleGroup: 'Shoulders'),
    LocalExercise(name: 'Pike Push-Ups', muscleGroup: 'Shoulders'),
    LocalExercise(name: 'Handstand Push-Ups', muscleGroup: 'Shoulders'),
    LocalExercise(name: 'Machine Shoulder Press', muscleGroup: 'Shoulders'),

    // BICEPS (12 exercises)
    LocalExercise(name: 'Barbell Curl', muscleGroup: 'Biceps'),
    LocalExercise(name: 'Dumbbell Curl', muscleGroup: 'Biceps'),
    LocalExercise(name: 'Hammer Curl', muscleGroup: 'Biceps'),
    LocalExercise(name: 'Preacher Curl', muscleGroup: 'Biceps'),
    LocalExercise(name: 'Concentration Curl', muscleGroup: 'Biceps'),
    LocalExercise(name: 'Cable Curl', muscleGroup: 'Biceps'),
    LocalExercise(name: 'Incline Dumbbell Curl', muscleGroup: 'Biceps'),
    LocalExercise(name: 'Spider Curl', muscleGroup: 'Biceps'),
    LocalExercise(name: 'Reverse Curl', muscleGroup: 'Biceps'),
    LocalExercise(name: 'Zottman Curl', muscleGroup: 'Biceps'),
    LocalExercise(name: '21s Curl', muscleGroup: 'Biceps'),
    LocalExercise(name: 'EZ Bar Curl', muscleGroup: 'Biceps'),

    // TRICEPS (12 exercises)
    LocalExercise(name: 'Close Grip Bench Press', muscleGroup: 'Triceps'),
    LocalExercise(name: 'Tricep Dips', muscleGroup: 'Triceps'),
    LocalExercise(name: 'Skull Crushers', muscleGroup: 'Triceps'),
    LocalExercise(name: 'Overhead Tricep Extension', muscleGroup: 'Triceps'),
    LocalExercise(name: 'Tricep Pushdown', muscleGroup: 'Triceps'),
    LocalExercise(name: 'Rope Pushdown', muscleGroup: 'Triceps'),
    LocalExercise(name: 'Diamond Push-Ups', muscleGroup: 'Triceps'),
    LocalExercise(name: 'Kickbacks', muscleGroup: 'Triceps'),
    LocalExercise(name: 'Dumbbell Tricep Extension', muscleGroup: 'Triceps'),
    LocalExercise(name: 'JM Press', muscleGroup: 'Triceps'),
    LocalExercise(name: 'Tate Press', muscleGroup: 'Triceps'),
    LocalExercise(name: 'Bench Dips', muscleGroup: 'Triceps'),

    // ABS/CORE (15 exercises)
    LocalExercise(name: 'Plank', muscleGroup: 'Abs'),
    LocalExercise(name: 'Crunches', muscleGroup: 'Abs'),
    LocalExercise(name: 'Sit-Ups', muscleGroup: 'Abs'),
    LocalExercise(name: 'Leg Raises', muscleGroup: 'Abs'),
    LocalExercise(name: 'Hanging Leg Raises', muscleGroup: 'Abs'),
    LocalExercise(name: 'Russian Twists', muscleGroup: 'Abs'),
    LocalExercise(name: 'Bicycle Crunches', muscleGroup: 'Abs'),
    LocalExercise(name: 'Mountain Climbers', muscleGroup: 'Abs'),
    LocalExercise(name: 'Ab Wheel Rollout', muscleGroup: 'Abs'),
    LocalExercise(name: 'Cable Crunches', muscleGroup: 'Abs'),
    LocalExercise(name: 'Side Plank', muscleGroup: 'Abs'),
    LocalExercise(name: 'V-Ups', muscleGroup: 'Abs'),
    LocalExercise(name: 'Flutter Kicks', muscleGroup: 'Abs'),
    LocalExercise(name: 'Dead Bug', muscleGroup: 'Abs'),
    LocalExercise(name: 'Pallof Press', muscleGroup: 'Abs'),

    // CARDIO (8 exercises)
    LocalExercise(name: 'Running', muscleGroup: 'Cardio'),
    LocalExercise(name: 'Cycling', muscleGroup: 'Cardio'),
    LocalExercise(name: 'Rowing', muscleGroup: 'Cardio'),
    LocalExercise(name: 'Jump Rope', muscleGroup: 'Cardio'),
    LocalExercise(name: 'Burpees', muscleGroup: 'Cardio'),
    LocalExercise(name: 'Stair Climber', muscleGroup: 'Cardio'),
    LocalExercise(name: 'Elliptical', muscleGroup: 'Cardio'),
    LocalExercise(name: 'Swimming', muscleGroup: 'Cardio'),
  ];

  // Get all exercises (preset + custom)
  Future<List<LocalExercise>> getAllExercises() async {
    final customBox = await Hive.openBox<LocalExercise>(_boxName);
    final customExercises = customBox.values.toList();
    return [..._presetExercises, ...customExercises];
  }

  // Search exercises by name (case-insensitive, partial match)
  Future<List<LocalExercise>> searchExercises(String query) async {
    if (query.isEmpty) {
      return _presetExercises.take(20).toList(); // Show first 20 by default
    }

    final allExercises = await getAllExercises();
    final lowerQuery = query.toLowerCase();

    return allExercises
        .where((exercise) =>
            exercise.name.toLowerCase().contains(lowerQuery) ||
            exercise.muscleGroup.toLowerCase().contains(lowerQuery))
        .toList();
  }

  // Add custom exercise (user-created)
  Future<void> addCustomExercise(String name, String muscleGroup) async {
    // Check if already exists
    final existing = await searchExercises(name);
    if (existing.any((ex) => ex.name.toLowerCase() == name.toLowerCase())) {
      return; // Already exists, don't add duplicate
    }

    final customBox = await Hive.openBox<LocalExercise>(_boxName);
    final customExercise = LocalExercise(
      name: name,
      muscleGroup: muscleGroup,
      isCustom: true,
    );
    await customBox.add(customExercise);
  }

  // Get all muscle groups
  List<String> getMuscleGroups() {
    return [
      'Chest',
      'Back',
      'Legs',
      'Shoulders',
      'Biceps',
      'Triceps',
      'Abs',
      'Cardio',
    ];
  }

  // Get exercises by muscle group
  Future<List<LocalExercise>> getExercisesByMuscleGroup(
      String muscleGroup) async {
    final allExercises = await getAllExercises();
    return allExercises
        .where((exercise) => exercise.muscleGroup == muscleGroup)
        .toList();
  }
}
