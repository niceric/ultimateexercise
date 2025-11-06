import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/components/animated_widgets.dart';
import 'package:trainingapp/models/workout_model.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:trainingapp/theme/app_theme.dart';

class ModernStatistics extends StatelessWidget {
  const ModernStatistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientContainer(
        child: SafeArea(
          child: Consumer<WorkoutProvider>(
            builder: (context, workoutProvider, child) {
              final finishedWorkouts = workoutProvider.workouts
                  .where((w) => w.isFinished)
                  .toList();

              final stats = _calculateStats(finishedWorkouts);

              return CustomScrollView(
                slivers: [
                  // Header
                  SliverToBoxAdapter(
                    child: FadeInAnimation(
                      delay: Duration(milliseconds: 100),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Statistics',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Your training insights',
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
                                    color:
                                        AppTheme.accentPurple.withOpacity(0.3),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.bar_chart_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 8)),

                  // Main Stats
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          FadeInAnimation(
                            delay: Duration(milliseconds: 200),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildMainStatCard(
                                    icon: Icons.fitness_center_rounded,
                                    label: 'Total Workouts',
                                    value: stats['totalWorkouts'].toString(),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.accentPurple,
                                        AppTheme.accentPurple.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _buildMainStatCard(
                                    icon: Icons.trending_up_rounded,
                                    label: 'Total Volume',
                                    value:
                                        '${stats['totalVolume'].toStringAsFixed(0)} kg',
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
                          SizedBox(height: 16),
                          FadeInAnimation(
                            delay: Duration(milliseconds: 300),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildMainStatCard(
                                    icon: Icons.repeat_rounded,
                                    label: 'Total Sets',
                                    value: stats['totalSets'].toString(),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppTheme.accentGreen,
                                        AppTheme.accentGreen.withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _buildMainStatCard(
                                    icon: Icons.timer_rounded,
                                    label: 'Total Time',
                                    value: _formatTotalDuration(
                                        stats['totalDuration']),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFF59E0B),
                                        Color(0xFFF59E0B).withOpacity(0.7),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // Averages Section
                  SliverToBoxAdapter(
                    child: FadeInAnimation(
                      delay: Duration(milliseconds: 400),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Averages',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16)),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          FadeInAnimation(
                            delay: Duration(milliseconds: 500),
                            child: _buildAverageCard(
                              icon: Icons.schedule_rounded,
                              label: 'Avg Workout Duration',
                              value: _formatTotalDuration(
                                  stats['avgDuration']),
                            ),
                          ),
                          SizedBox(height: 12),
                          FadeInAnimation(
                            delay: Duration(milliseconds: 600),
                            child: _buildAverageCard(
                              icon: Icons.fitness_center_rounded,
                              label: 'Avg Exercises per Workout',
                              value:
                                  stats['avgExercises'].toStringAsFixed(1),
                            ),
                          ),
                          SizedBox(height: 12),
                          FadeInAnimation(
                            delay: Duration(milliseconds: 700),
                            child: _buildAverageCard(
                              icon: Icons.repeat_rounded,
                              label: 'Avg Sets per Workout',
                              value: stats['avgSets'].toStringAsFixed(1),
                            ),
                          ),
                          SizedBox(height: 12),
                          FadeInAnimation(
                            delay: Duration(milliseconds: 800),
                            child: _buildAverageCard(
                              icon: Icons.trending_up_rounded,
                              label: 'Avg Volume per Workout',
                              value:
                                  '${stats['avgVolume'].toStringAsFixed(0)} kg',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // Recent Activity
                  SliverToBoxAdapter(
                    child: FadeInAnimation(
                      delay: Duration(milliseconds: 900),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Recent Activity',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // Activity Chart
                  SliverToBoxAdapter(
                    child: FadeInAnimation(
                      delay: Duration(milliseconds: 1000),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: _buildActivityChart(finishedWorkouts),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // Top Exercises
                  if (stats['topExercises'].isNotEmpty) ...[
                    SliverToBoxAdapter(
                      child: FadeInAnimation(
                        delay: Duration(milliseconds: 1100),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            'Most Trained Exercises',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(child: SizedBox(height: 16)),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final exercise = stats['topExercises'][index];
                          return FadeInAnimation(
                            delay:
                                Duration(milliseconds: 1200 + (index * 100)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 6.0,
                              ),
                              child: _buildExerciseCard(
                                exercise['name'],
                                exercise['count'],
                              ),
                            ),
                          );
                        },
                        childCount: stats['topExercises'].length > 5
                            ? 5
                            : stats['topExercises'].length,
                      ),
                    ),
                  ],

                  SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> _calculateStats(List<Workout> workouts) {
    if (workouts.isEmpty) {
      return {
        'totalWorkouts': 0,
        'totalVolume': 0.0,
        'totalSets': 0,
        'totalDuration': 0,
        'avgDuration': 0,
        'avgExercises': 0.0,
        'avgSets': 0.0,
        'avgVolume': 0.0,
        'topExercises': [],
      };
    }

    int totalSets = 0;
    double totalVolume = 0;
    int totalDuration = 0;
    int totalExercises = 0;
    Map<String, int> exerciseCounts = {};

    for (var workout in workouts) {
      totalSets += workout.totalSets;
      totalVolume += workout.totalVolume;
      totalDuration += int.tryParse(workout.duration) ?? 0;
      totalExercises += workout.exercises.length;

      for (var exercise in workout.exercises) {
        exerciseCounts[exercise.exerciseName] =
            (exerciseCounts[exercise.exerciseName] ?? 0) + 1;
      }
    }

    // Sort exercises by count
    var sortedExercises = exerciseCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    var topExercises = sortedExercises
        .map((e) => {'name': e.key, 'count': e.value})
        .toList();

    return {
      'totalWorkouts': workouts.length,
      'totalVolume': totalVolume,
      'totalSets': totalSets,
      'totalDuration': totalDuration,
      'avgDuration': totalDuration / workouts.length,
      'avgExercises': totalExercises / workouts.length,
      'avgSets': totalSets / workouts.length,
      'avgVolume': totalVolume / workouts.length,
      'topExercises': topExercises,
    };
  }

  String _formatTotalDuration(dynamic seconds) {
    int totalSeconds = (seconds is double) ? seconds.round() : seconds as int;
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Widget _buildMainStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Gradient gradient,
  }) {
    return GradientCard(
      gradient: gradient,
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAverageCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return GradientCard(
      gradient: LinearGradient(
        colors: [
          AppTheme.cardDark,
          AppTheme.cardDark.withOpacity(0.8),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppTheme.purpleGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.accentCyan,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityChart(List<Workout> workouts) {
    // Get last 7 days
    final now = DateTime.now();
    final last7Days = List.generate(7, (i) {
      return now.subtract(Duration(days: 6 - i));
    });

    // Count workouts per day
    final workoutsPerDay = List.generate(7, (i) {
      final day = last7Days[i];
      return workouts.where((w) {
        return w.date.year == day.year &&
            w.date.month == day.month &&
            w.date.day == day.day;
      }).length;
    });

    final maxWorkouts = workoutsPerDay.reduce((a, b) => a > b ? a : b);
    final chartHeight = maxWorkouts == 0 ? 1.0 : maxWorkouts.toDouble();

    return GradientCard(
      gradient: LinearGradient(
        colors: [
          AppTheme.cardDark,
          AppTheme.cardDark.withOpacity(0.8),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Last 7 Days',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final count = workoutsPerDay[index];
              final height = maxWorkouts == 0
                  ? 20.0
                  : (count / chartHeight) * 100 + 20;
              final day = last7Days[index];
              final dayName = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  [day.weekday - 1];

              return Column(
                children: [
                  if (count > 0)
                    Text(
                      count.toString(),
                      style: TextStyle(
                        color: AppTheme.accentCyan,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (count > 0) SizedBox(height: 4),
                  Container(
                    width: 32,
                    height: height,
                    decoration: BoxDecoration(
                      gradient: count > 0
                          ? LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                AppTheme.accentPurple,
                                AppTheme.accentCyan,
                              ],
                            )
                          : null,
                      color: count == 0
                          ? Colors.white.withOpacity(0.1)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    dayName,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(String name, int count) {
    return GradientCard(
      gradient: LinearGradient(
        colors: [
          AppTheme.cardDark,
          AppTheme.cardDark.withOpacity(0.8),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: AppTheme.purpleGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.fitness_center_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.accentCyan.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count times',
              style: TextStyle(
                color: AppTheme.accentCyan,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
