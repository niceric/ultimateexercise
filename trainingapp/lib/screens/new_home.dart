import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/theme/app_theme.dart';
import 'package:trainingapp/components/animated_widgets.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:intl/intl.dart';

class NewHomeScreen extends StatelessWidget {
  const NewHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientContainer(
        child: SafeArea(
          child: Consumer<WorkoutProvider>(
            builder: (context, workoutProvider, child) {
              final workouts = workoutProvider.workouts;
              final thisWeekWorkouts = workouts.where((w) {
                final now = DateTime.now();
                final weekAgo = now.subtract(Duration(days: 7));
                return w.date.isAfter(weekAgo) && w.isFinished;
              }).length;

              return SingleChildScrollView(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    FadeInAnimation(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome Back',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white60,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Let\'s Get Strong',
                            style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: FadeInAnimation(
                            delay: Duration(milliseconds: 100),
                            child: _buildStatCard(
                              'Total Workouts',
                              workouts.where((w) => w.isFinished).length.toString(),
                              Icons.fitness_center,
                              AppTheme.purpleGradient,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: FadeInAnimation(
                            delay: Duration(milliseconds: 200),
                            child: _buildStatCard(
                              'This Week',
                              thisWeekWorkouts.toString(),
                              Icons.calendar_today,
                              AppTheme.cyanGradient,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 32),

                    // Start Workout CTA
                    FadeInAnimation(
                      delay: Duration(milliseconds: 300),
                      child: GestureDetector(
                        onTap: () {
                          // Navigate to workout creation
                          workoutProvider.addWorkout();
                          // TODO: Navigate to workout screen
                        },
                        child: Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: AppTheme.greenGradient,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accentGreen.withOpacity(0.5),
                                blurRadius: 30,
                                offset: Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                              SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start New Workout',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Time to get stronger!',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 32),

                    // Recent Workouts
                    FadeInAnimation(
                      delay: Duration(milliseconds: 400),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Workouts',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Navigate to history
                            },
                            child: Text(
                              'See All',
                              style: TextStyle(
                                color: AppTheme.accentCyan,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    // Recent Workout List
                    ...workouts
                        .where((w) => w.isFinished)
                        .take(5)
                        .toList()
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key;
                      final workout = entry.value;
                      return FadeInAnimation(
                        delay: Duration(milliseconds: 500 + (index * 100)),
                        child: _buildRecentWorkoutCard(workout),
                      );
                    }).toList(),

                    if (workouts.where((w) => w.isFinished).isEmpty)
                      FadeInAnimation(
                        delay: Duration(milliseconds: 500),
                        child: Container(
                          padding: EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceDark,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.fitness_center,
                                size: 64,
                                color: AppTheme.accentPurple.withOpacity(0.5),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No workouts yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Start your first workout to begin tracking!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white38,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Gradient gradient) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentWorkoutCard(Workout workout) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.accentPurple.withOpacity(0.3),
          width: 1,
        ),
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
              Icons.fitness_center,
              color: Colors.white,
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout.workoutName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: Colors.white60),
                    SizedBox(width: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(workout.date),
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.fitness_center, size: 12, color: Colors.white60),
                    SizedBox(width: 4),
                    Text(
                      '${workout.exercises.length} exercises',
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.white30,
            size: 16,
          ),
        ],
      ),
    );
  }
}
