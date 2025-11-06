import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/components/animated_widgets.dart';
import 'package:trainingapp/models/workout_model.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:trainingapp/theme/app_theme.dart';
import 'package:intl/intl.dart';

class ModernHistory extends StatelessWidget {
  const ModernHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientContainer(
        child: SafeArea(
          child: Consumer<WorkoutProvider>(
            builder: (context, workoutProvider, child) {
              final allWorkouts = workoutProvider.workouts
                  .where((w) => w.isFinished)
                  .toList()
                  .reversed
                  .toList();

              // Group workouts by month
              Map<String, List<Workout>> groupedWorkouts = {};
              for (var workout in allWorkouts) {
                String monthKey = DateFormat('MMMM yyyy').format(workout.date);
                if (!groupedWorkouts.containsKey(monthKey)) {
                  groupedWorkouts[monthKey] = [];
                }
                groupedWorkouts[monthKey]!.add(workout);
              }

              return CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: FadeInAnimation(
                      delay: Duration(milliseconds: 100),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Workout History',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '${allWorkouts.length} workouts completed',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.purpleGradient,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.accentPurple
                                            .withOpacity(0.3),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.history_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 8)),

                  // Quick Stats
                  SliverToBoxAdapter(
                    child: FadeInAnimation(
                      delay: Duration(milliseconds: 200),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildQuickStat(
                                icon: Icons.local_fire_department_rounded,
                                label: 'Total Volume',
                                value:
                                    '${_calculateTotalVolume(allWorkouts).toStringAsFixed(0)} kg',
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFF59E0B),
                                    Color(0xFFF59E0B).withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: _buildQuickStat(
                                icon: Icons.repeat_rounded,
                                label: 'Total Sets',
                                value: _calculateTotalSets(allWorkouts)
                                    .toString(),
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.accentCyan,
                                    AppTheme.accentCyan.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Workouts List
                  if (allWorkouts.isEmpty)
                    SliverFillRemaining(
                      child: FadeInAnimation(
                        delay: Duration(milliseconds: 300),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history_rounded,
                                size: 80,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'No workout history yet',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Complete your first workout to see it here!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    ...groupedWorkouts.entries.map((entry) {
                      return SliverList(
                        delegate: SliverChildListDelegate([
                          // Month Header
                          FadeInAnimation(
                            delay: Duration(milliseconds: 300),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 8.0, 20.0, 12.0),
                              child: Text(
                                entry.key,
                                style: TextStyle(
                                  color: AppTheme.accentCyan,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // Workouts in this month
                          ...entry.value.asMap().entries.map((workoutEntry) {
                            return FadeInAnimation(
                              delay: Duration(
                                  milliseconds:
                                      400 + (workoutEntry.key * 50)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 6.0,
                                ),
                                child: _buildWorkoutCard(
                                    context, workoutEntry.value),
                              ),
                            );
                          }).toList(),
                          SizedBox(height: 16),
                        ]),
                      );
                    }).toList(),

                  SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  double _calculateTotalVolume(List<Workout> workouts) {
    return workouts.fold(0, (sum, workout) => sum + workout.totalVolume);
  }

  int _calculateTotalSets(List<Workout> workouts) {
    return workouts.fold(0, (sum, workout) => sum + workout.totalSets);
  }

  Widget _buildQuickStat({
    required IconData icon,
    required String label,
    required String value,
    required Gradient gradient,
  }) {
    return GradientCard(
      gradient: gradient,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(BuildContext context, Workout workout) {
    return GestureDetector(
      onTap: () {
        _showWorkoutDetails(context, workout);
      },
      child: GradientCard(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.cardDark,
            AppTheme.cardDark.withOpacity(0.8),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    workout.workoutName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: AppTheme.purpleGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(workout.date),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _buildStat(
                  Icons.fitness_center_rounded,
                  '${workout.exercises.length} exercises',
                ),
                SizedBox(width: 16),
                _buildStat(
                  Icons.repeat_rounded,
                  '${workout.totalSets} sets',
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                _buildStat(
                  Icons.timer_rounded,
                  workout.formattedDuration,
                ),
                SizedBox(width: 16),
                if (workout.totalVolume > 0)
                  _buildStat(
                    Icons.trending_up_rounded,
                    '${workout.totalVolume.toStringAsFixed(0)} kg',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.accentCyan,
          size: 16,
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  void _showWorkoutDetails(BuildContext context, Workout workout) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.cardDark,
              AppTheme.primaryDark,
            ],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    workout.workoutName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    DateFormat('EEEE, MMMM dd, yyyy').format(workout.date),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    child: _buildDetailStat(
                      Icons.timer_rounded,
                      'Duration',
                      workout.formattedDuration,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildDetailStat(
                      Icons.repeat_rounded,
                      'Sets',
                      workout.totalSets.toString(),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildDetailStat(
                      Icons.trending_up_rounded,
                      'Volume',
                      '${workout.totalVolume.toStringAsFixed(0)} kg',
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Exercises List
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20),
                itemCount: workout.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = workout.exercises[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDark.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppTheme.accentPurple.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: AppTheme.purpleGradient,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.fitness_center_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  exercise.exerciseName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (exercise.exerciseSets.isNotEmpty) ...[
                            SizedBox(height: 12),
                            ...exercise.exerciseSets
                                .asMap()
                                .entries
                                .map((entry) {
                              final setIndex = entry.key;
                              final set = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Row(
                                  children: [
                                    SizedBox(width: 36),
                                    Text(
                                      'Set ${setIndex + 1}:',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      '${set.reps} reps',
                                      style: TextStyle(
                                        color: AppTheme.accentCyan,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      ' × ',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.5),
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      '${set.weight} kg',
                                      style: TextStyle(
                                        color: AppTheme.accentGreen,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailStat(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.accentPurple.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppTheme.accentCyan,
            size: 20,
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
