import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/theme/app_theme.dart';
import 'package:trainingapp/components/animated_widgets.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:trainingapp/models/workout_model.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  const ActiveWorkoutScreen({Key? key}) : super(key: key);

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientContainer(
        child: SafeArea(
          child: Consumer<WorkoutProvider>(
            builder: (context, workoutProvider, child) {
              final currentWorkout = workoutProvider.workouts.last;

              return Column(
                children: [
                  // Header with Timer
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppTheme.purpleGradient,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentPurple.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                              onPressed: () {
                                _showExitDialog(context, workoutProvider, currentWorkout);
                              },
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    currentWorkout.workoutName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _formatTime(_elapsedSeconds),
                                    style: TextStyle(
                                      fontSize: 32,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 48),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatPill(
                              '${currentWorkout.exercises.length}',
                              'Exercises',
                              Icons.fitness_center,
                            ),
                            _buildStatPill(
                              '${currentWorkout.totalSets}',
                              'Sets',
                              Icons.repeat,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Exercises List
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(20),
                      itemCount: currentWorkout.exercises.length,
                      itemBuilder: (context, exerciseIndex) {
                        final exercise = currentWorkout.exercises[exerciseIndex];
                        return FadeInAnimation(
                          delay: Duration(milliseconds: 100 * exerciseIndex),
                          child: _buildExerciseCard(
                            context,
                            workoutProvider,
                            currentWorkout,
                            exercise,
                            exerciseIndex,
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom Action Button
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryDark,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: Offset(0, -5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExerciseSelectionScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceDark,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppTheme.accentCyan,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add, color: AppTheme.accentCyan),
                                  SizedBox(width: 8),
                                  Text(
                                    'Add Exercise',
                                    style: TextStyle(
                                      color: AppTheme.accentCyan,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              _finishWorkout(context, workoutProvider, currentWorkout);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                gradient: AppTheme.greenGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.accentGreen.withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Finish',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatPill(String value, String label, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(
    BuildContext context,
    WorkoutProvider workoutProvider,
    Workout workout,
    Exercise exercise,
    int exerciseIndex,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentCyan.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: AppTheme.cyanGradient,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.fitness_center, color: Colors.white, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.exerciseName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        exercise.muscleGroup,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sets List
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Sets Header
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text('Set', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('Reps', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text('Weight', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    ),
                    SizedBox(width: 40),
                  ],
                ),
                SizedBox(height: 8),

                // Existing Sets
                ...exercise.sets.asMap().entries.map((entry) {
                  final setIndex = entry.key;
                  final set = entry.value;
                  return _buildSetRow(
                    context,
                    workoutProvider,
                    workout,
                    exerciseIndex,
                    setIndex,
                    set,
                  );
                }).toList(),

                SizedBox(height: 8),

                // Add Set Button
                GestureDetector(
                  onTap: () {
                    workoutProvider.addSetToExercise(
                      workout.id,
                      exerciseIndex,
                      10,
                      0,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentCyan.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.accentCyan.withOpacity(0.5),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, color: AppTheme.accentCyan, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Add Set',
                          style: TextStyle(
                            color: AppTheme.accentCyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetRow(
    BuildContext context,
    WorkoutProvider workoutProvider,
    Workout workout,
    int exerciseIndex,
    int setIndex,
    WorkoutSet set,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Set Number
          Expanded(
            flex: 2,
            child: Text(
              '${set.setNumber}',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Reps Input
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () {
                _showNumberPicker(
                  context,
                  'Reps',
                  set.reps,
                  1,
                  100,
                  (value) {
                    workoutProvider.updateSet(
                      workout.id,
                      exerciseIndex,
                      setIndex,
                      value,
                      set.weight,
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${set.reps}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          SizedBox(width: 8),

          // Weight Input
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () {
                _showNumberPicker(
                  context,
                  'Weight (kg)',
                  set.weight.toInt(),
                  0,
                  500,
                  (value) {
                    workoutProvider.updateSet(
                      workout.id,
                      exerciseIndex,
                      setIndex,
                      set.reps,
                      value.toDouble(),
                    );
                  },
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${set.weight.toInt()} kg',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          SizedBox(width: 8),

          // Checkmark
          Icon(
            Icons.check_circle,
            color: AppTheme.accentGreen,
            size: 24,
          ),
        ],
      ),
    );
  }

  void _showNumberPicker(
    BuildContext context,
    String title,
    int initialValue,
    int min,
    int max,
    Function(int) onConfirm,
  ) {
    int selectedValue = initialValue;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (selectedValue > min) {
                            setState(() => selectedValue--);
                          }
                        },
                        icon: Icon(Icons.remove_circle, color: AppTheme.accentCyan, size: 40),
                      ),
                      SizedBox(width: 32),
                      Text(
                        '$selectedValue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 32),
                      IconButton(
                        onPressed: () {
                          if (selectedValue < max) {
                            setState(() => selectedValue++);
                          }
                        },
                        icon: Icon(Icons.add_circle, color: AppTheme.accentCyan, size: 40),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      onConfirm(selectedValue);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: AppTheme.greenGradient,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showExitDialog(BuildContext context, WorkoutProvider workoutProvider, Workout workout) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text('Exit Workout?', style: TextStyle(color: Colors.white)),
          content: Text(
            'Are you sure you want to exit? Your progress will be lost.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.white60)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Close workout screen
              },
              child: Text('Exit', style: TextStyle(color: AppTheme.accentPink)),
            ),
          ],
        );
      },
    );
  }

  void _finishWorkout(BuildContext context, WorkoutProvider workoutProvider, Workout workout) {
    // Save duration
    workoutProvider.setWorkoutDuration(_elapsedSeconds.toString(), workout.id);
    // Mark as finished
    workoutProvider.updateWorkoutStatus(workout.id);

    // Navigate to completion screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutCompleteScreen(workout: workout),
      ),
    );
  }
}

// Placeholder screens
class ExerciseSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Select Exercise')),
      body: Center(child: Text('Exercise Selection - Coming next!', style: TextStyle(color: Colors.white))),
    );
  }
}

class WorkoutCompleteScreen extends StatelessWidget {
  final Workout workout;
  const WorkoutCompleteScreen({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout Complete!')),
      body: Center(child: Text('Completion Screen - Coming next!', style: TextStyle(color: Colors.white))),
    );
  }
}
