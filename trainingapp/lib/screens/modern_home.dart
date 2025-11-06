import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/components/animated_widgets.dart';
import 'package:trainingapp/components/modern_bottom_nav.dart';
import 'package:trainingapp/models/workout_model.dart';
import 'package:trainingapp/screens/workout_setup_screen.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:trainingapp/theme/app_theme.dart';
import 'package:intl/intl.dart';

class ModernHome extends StatelessWidget {
  final Function(int) onNavigate;

  const ModernHome({Key? key, required this.onNavigate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientContainer(
        child: SafeArea(
          child: Consumer<WorkoutProvider>(
            builder: (context, workoutProvider, child) {
              final allWorkouts = workoutProvider.workouts;
              final finishedWorkouts =
                  allWorkouts.where((w) => w.isFinished).toList();
              final thisWeekWorkouts = finishedWorkouts.where((w) {
                final now = DateTime.now();
                final startOfWeek =
                    now.subtract(Duration(days: now.weekday - 1));
                return w.date.isAfter(startOfWeek);
              }).toList();

              return CustomScrollView(
                slivers: [
                  // App Bar
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
                                      _getGreeting(),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      workoutProvider.userName.isEmpty
                                          ? 'Athlete'
                                          : workoutProvider.userName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
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
                                    Icons.emoji_events_rounded,
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

                  // Stats Cards
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: FadeInAnimation(
                              delay: Duration(milliseconds: 200),
                              child: _buildStatCard(
                                icon: Icons.fitness_center_rounded,
                                label: 'Total Workouts',
                                value: finishedWorkouts.length.toString(),
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.accentPurple,
                                    AppTheme.accentPurple.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: FadeInAnimation(
                              delay: Duration(milliseconds: 300),
                              child: _buildStatCard(
                                icon: Icons.local_fire_department_rounded,
                                label: 'This Week',
                                value: thisWeekWorkouts.length.toString(),
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.accentCyan,
                                    AppTheme.accentCyan.withOpacity(0.7),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // Start Workout CTA
                  SliverToBoxAdapter(
                    child: FadeInAnimation(
                      delay: Duration(milliseconds: 400),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            workoutProvider.addWorkout();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutSetupScreen(
                                  workout: workoutProvider.latestWorkout!,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.accentGreen,
                                  AppTheme.accentGreen.withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.accentGreen.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 32,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Start New Workout',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // Recent Workouts Header
                  SliverToBoxAdapter(
                    child: FadeInAnimation(
                      delay: Duration(milliseconds: 500),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Workouts',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (finishedWorkouts.isNotEmpty)
                              GestureDetector(
                                onTap: () => onNavigate(1),
                                child: Text(
                                  'See All',
                                  style: TextStyle(
                                    color: AppTheme.accentCyan,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: 16)),

                  // Recent Workouts List
                  if (finishedWorkouts.isEmpty)
                    SliverToBoxAdapter(
                      child: FadeInAnimation(
                        delay: Duration(milliseconds: 600),
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.fitness_center_rounded,
                                size: 64,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No workouts yet',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Start your first workout to see it here!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final workout = finishedWorkouts.reversed
                              .toList()[index];
                          return FadeInAnimation(
                            delay: Duration(milliseconds: 600 + (index * 100)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 8.0,
                              ),
                              child: _buildWorkoutCard(workout),
                            ),
                          );
                        },
                        childCount: finishedWorkouts.length > 5
                            ? 5
                            : finishedWorkouts.length,
                      ),
                    ),

                  SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Gradient gradient,
  }) {
    return GradientCard(
      gradient: gradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(Workout workout) {
    return GradientCard(
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
                  DateFormat('MMM dd').format(workout.date),
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
              _buildWorkoutStat(
                Icons.fitness_center_rounded,
                '${workout.exercises.length} exercises',
              ),
              SizedBox(width: 16),
              _buildWorkoutStat(
                Icons.timer_rounded,
                workout.formattedDuration,
              ),
            ],
          ),
          if (workout.totalVolume > 0) ...[
            SizedBox(height: 8),
            _buildWorkoutStat(
              Icons.trending_up_rounded,
              '${workout.totalVolume.toStringAsFixed(0)} kg total',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWorkoutStat(IconData icon, String text) {
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
}
