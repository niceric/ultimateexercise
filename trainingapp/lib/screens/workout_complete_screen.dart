import 'package:flutter/material.dart';
import 'package:trainingapp/components/animated_widgets.dart';
import 'package:trainingapp/models/workout_model.dart';
import 'package:trainingapp/theme/app_theme.dart';

class WorkoutCompleteScreen extends StatefulWidget {
  final Workout workout;

  const WorkoutCompleteScreen({Key? key, required this.workout})
      : super(key: key);

  @override
  State<WorkoutCompleteScreen> createState() => _WorkoutCompleteScreenState();
}

class _WorkoutCompleteScreenState extends State<WorkoutCompleteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _celebrationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _celebrationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _celebrationController,
        curve: Curves.elasticOut,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _celebrationController,
        curve: Curves.easeInOut,
      ),
    );

    _celebrationController.forward();
  }

  @override
  void dispose() {
    _celebrationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientContainer(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        SizedBox(height: 40),

                        // Celebration Icon
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: RotationTransition(
                            turns: _rotateAnimation,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.accentGreen,
                                    AppTheme.accentCyan,
                                  ],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        AppTheme.accentGreen.withOpacity(0.5),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.emoji_events_rounded,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 32),

                        // Title
                        FadeInAnimation(
                          delay: Duration(milliseconds: 500),
                          child: Text(
                            'Workout Complete!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: 8),

                        FadeInAnimation(
                          delay: Duration(milliseconds: 600),
                          child: Text(
                            'Great job! You crushed it 💪',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                            ),
                          ),
                        ),

                        SizedBox(height: 40),

                        // Workout Name
                        FadeInAnimation(
                          delay: Duration(milliseconds: 700),
                          child: GradientCard(
                            gradient: LinearGradient(
                              colors: [
                                AppTheme.accentPurple.withOpacity(0.3),
                                AppTheme.accentCyan.withOpacity(0.2),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.fitness_center_rounded,
                                  color: AppTheme.accentCyan,
                                  size: 32,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  widget.workout.workoutName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 24),

                        // Stats Grid
                        FadeInAnimation(
                          delay: Duration(milliseconds: 800),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  icon: Icons.timer_rounded,
                                  label: 'Duration',
                                  value: widget.workout.formattedDuration,
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
                                child: _buildStatCard(
                                  icon: Icons.fitness_center_rounded,
                                  label: 'Exercises',
                                  value: widget.workout.exercises.length
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

                        SizedBox(height: 16),

                        FadeInAnimation(
                          delay: Duration(milliseconds: 900),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  icon: Icons.repeat_rounded,
                                  label: 'Total Sets',
                                  value: widget.workout.totalSets.toString(),
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
                                child: _buildStatCard(
                                  icon: Icons.trending_up_rounded,
                                  label: 'Total Volume',
                                  value: widget.workout.totalVolume > 0
                                      ? '${widget.workout.totalVolume.toStringAsFixed(0)} kg'
                                      : '0 kg',
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

                        SizedBox(height: 32),

                        // Exercise Breakdown
                        FadeInAnimation(
                          delay: Duration(milliseconds: 1000),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Exercise Breakdown',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 16),
                              ...widget.workout.exercises.map((exercise) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: GradientCard(
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
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.fitness_center_rounded,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                exercise.exerciseName,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '${exercise.exerciseSets.length} sets',
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.6),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: AppTheme.accentGreen,
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),

                        SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FadeInAnimation(
        delay: Duration(milliseconds: 1100),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: ElevatedButton(
            onPressed: () {
              // Pop all screens and return to home
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentGreen,
                    AppTheme.accentCyan,
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentGreen.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.home_rounded, size: 24),
                    SizedBox(width: 12),
                    Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
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
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
