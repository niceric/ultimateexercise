import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/theme/app_theme.dart';
import 'package:trainingapp/components/animated_widgets.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:trainingapp/models/workout_model.dart';

class WorkoutSetupScreen extends StatefulWidget {
  const WorkoutSetupScreen({Key? key}) : super(key: key);

  @override
  State<WorkoutSetupScreen> createState() => _WorkoutSetupScreenState();
}

class _WorkoutSetupScreenState extends State<WorkoutSetupScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientContainer(
        child: SafeArea(
          child: Consumer<WorkoutProvider>(
            builder: (context, workoutProvider, child) {
              // Get or create current workout
              if (workoutProvider.workouts.isEmpty ||
                  workoutProvider.workouts.last.isFinished) {
                workoutProvider.addWorkout();
              }

              final currentWorkout = workoutProvider.workouts.last;

              if (_nameController.text.isEmpty &&
                  currentWorkout.workoutName != 'Workout of the day') {
                _nameController.text = currentWorkout.workoutName;
              }

              return Column(
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            'New Workout',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(width: 48), // Balance the back button
                      ],
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Workout Name Card
                          FadeInAnimation(
                            delay: Duration(milliseconds: 100),
                            child: GradientCard(
                              gradient: AppTheme.purpleGradient,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.edit_note,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Workout Name',
                                              style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 12,
                                              ),
                                            ),
                                            TextField(
                                              controller: _nameController,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Name your workout...',
                                                hintStyle: TextStyle(
                                                  color: Colors.white60,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                contentPadding: EdgeInsets.zero,
                                              ),
                                              onChanged: (value) {
                                                workoutProvider.setWorkoutName(
                                                  value.isEmpty ? 'Workout of the day' : value,
                                                  currentWorkout.id,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 24),

                          // Quick Stats
                          FadeInAnimation(
                            delay: Duration(milliseconds: 200),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildQuickStat(
                                    'Exercises',
                                    currentWorkout.exercises.length.toString(),
                                    Icons.fitness_center,
                                    AppTheme.accentCyan,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildQuickStat(
                                    'Sets',
                                    currentWorkout.totalSets.toString(),
                                    Icons.repeat,
                                    AppTheme.accentPink,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 32),

                          // Exercises Section Header
                          FadeInAnimation(
                            delay: Duration(milliseconds: 300),
                            child: Text(
                              'Exercises',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(height: 16),

                          // Exercises List or Empty State
                          if (currentWorkout.exercises.isEmpty)
                            FadeInAnimation(
                              delay: Duration(milliseconds: 400),
                              child: Container(
                                padding: EdgeInsets.all(40),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceDark,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppTheme.accentPurple.withOpacity(0.3),
                                    width: 2,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accentPurple.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.add_circle_outline,
                                        size: 48,
                                        color: AppTheme.accentPurple,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'No exercises yet',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Add exercises to start your workout',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white60,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            ...currentWorkout.exercises
                                .asMap()
                                .entries
                                .map((entry) {
                              final index = entry.key;
                              final exercise = entry.value;
                              return FadeInAnimation(
                                delay: Duration(milliseconds: 400 + (index * 100)),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceDark,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: AppTheme.accentCyan.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          gradient: AppTheme.cyanGradient,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.fitness_center,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              exercise.exerciseName,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '${exercise.sets.length} sets',
                                              style: TextStyle(
                                                color: AppTheme.accentCyan,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.chevron_right,
                                        color: Colors.white30,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),

                          SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Actions
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Add Exercise Button
                        ScaleAnimation(
                          delay: Duration(milliseconds: 200),
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to exercise selection
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExerciseSelectionScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                gradient: AppTheme.cyanGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.accentCyan.withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_circle_outline, color: Colors.white),
                                  SizedBox(width: 12),
                                  Text(
                                    'Add Exercise',
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

                        if (currentWorkout.exercises.isNotEmpty) ...[
                          SizedBox(height: 12),
                          // Start Workout Button
                          ScaleAnimation(
                            delay: Duration(milliseconds: 300),
                            child: GestureDetector(
                              onTap: () {
                                // Navigate to active workout
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActiveWorkoutScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
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
                                    Icon(Icons.play_arrow, color: Colors.white),
                                    SizedBox(width: 12),
                                    Text(
                                      'Start Workout',
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

  Widget _buildQuickStat(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    );
  }
}

// Placeholder for exercise selection (will modernize existing)
class ExerciseSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Exercise Selection - Coming next!', style: TextStyle(color: Colors.white))),
    );
  }
}

// Placeholder for active workout (building next)
class ActiveWorkoutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Active Workout - Coming next!', style: TextStyle(color: Colors.white))),
    );
  }
}
