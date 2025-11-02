# Hive Database Setup Instructions

## Overview

The app has been updated to use **Hive** as the local database instead of SharedPreferences. This allows proper storage of nested objects (Workouts → Exercises → WorkoutSets) with all data including reps and weights.

## What Changed

### Before (SharedPreferences)
- Used manual JSON serialization with `toJson()` and `fromJson()`
- Could not properly save nested set data (reps, weights)
- Data structure had to be flattened

### After (Hive)
- Automatic serialization of nested objects
- Full support for all workout data including sets, reps, and weights
- Cleaner, more maintainable code

## Setup Steps

### 1. Install Dependencies

```bash
cd trainingapp
flutter pub get
```

### 2. Generate Hive Type Adapters

You need to generate the type adapter files that Hive uses for serialization:

**Option A: Use the build script (recommended)**
```bash
chmod +x build.sh
./build.sh
```

**Option B: Manual command**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate `lib/models/workout_model.g.dart` which contains the type adapters.

### 3. Run the App

```bash
flutter run
```

## Data Models

All three models are now Hive-enabled:

```dart
@HiveType(typeId: 0)
class WorkoutSet {
  @HiveField(0) int setNumber;
  @HiveField(1) int reps;
  @HiveField(2) double weight;
}

@HiveType(typeId: 1)
class Exercise {
  @HiveField(0) String exerciseName;
  @HiveField(1) String muscleGroup;
  @HiveField(2) List<WorkoutSet> sets;
}

@HiveType(typeId: 2)
class Workout {
  @HiveField(0) String id;
  @HiveField(1) String workoutName;
  @HiveField(2) DateTime date;
  @HiveField(3) String time;
  @HiveField(4) List<String> weather;
  @HiveField(5) List<Exercise> exercises;
  @HiveField(6) bool isFinished;
}
```

## Migration Notes

### Existing Data
- Old SharedPreferences data will not be automatically migrated
- Users will start with a clean database
- If you need to migrate existing data, you'll need to write a migration script

### Storage Location
- Hive stores data in the app's documents directory
- Data persists across app restarts
- Data is cleared when the app is uninstalled

## Files Modified

1. **pubspec.yaml** - Added Hive dependencies
2. **lib/models/workout_model.dart** - Added Hive annotations, removed JSON methods
3. **lib/states/workout_handler.dart** - Updated to use Hive instead of SharedPreferences
4. **lib/main.dart** - Added Hive initialization

## Troubleshooting

### Build fails with "part 'workout_model.g.dart' not found"
Run the build_runner to generate the missing file:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Data not persisting
1. Check that Hive is initialized in main.dart before runApp()
2. Verify that saveWorkoutList() is being called when updating workouts
3. Check for errors in the console

### Need to reset the database
Delete the Hive box:
```dart
await Hive.deleteBoxFromDisk('workouts');
```

## Resources

- [Hive Documentation](https://docs.hivedb.dev/)
- [Hive Flutter Package](https://pub.dev/packages/hive_flutter)
- [Build Runner](https://pub.dev/packages/build_runner)
