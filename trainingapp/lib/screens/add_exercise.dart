import 'package:flutter/material.dart';
import 'package:trainingapp/components/bottom_appbar.dart';
import 'package:trainingapp/models/local_exercise.dart';
import 'package:trainingapp/services/exercise_service.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:trainingapp/components/animated_widgets.dart';
import 'package:trainingapp/theme/app_theme.dart';

class AddExercise extends ChangeNotifier {
  List<LocalExercise> result = [];
  final ExerciseService _exerciseService = ExerciseService();

  Future<void> getExercises(String input) async {
    List<LocalExercise> results = await _exerciseService.searchExercises(input);
    result = results;
    notifyListeners();
  }

  Future<void> addCustomExercise(String name, String muscleGroup) async {
    await _exerciseService.addCustomExercise(name, muscleGroup);
    // Refresh the list to include the new custom exercise
    await getExercises(name);
  }
}

class AddExerciseSearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.go('/create_workout'),
        ),
        title: FadeInAnimation(
          child: Text('Add Exercise',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AnimatedGradientContainer(
        child: SafeArea(
          child: Column(
            children: [
              // Search Bar
              FadeInAnimation(
                delay: Duration(milliseconds: 100),
                child: Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppTheme.purpleGradient,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentPurple.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "Search exercises...",
                      hintStyle: TextStyle(color: Colors.white60),
                      prefixIcon: Icon(Icons.search, color: Colors.white70, size: 28),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.white70),
                              onPressed: () {
                                searchController.clear();
                                context.read<AddExercise>().getExercises('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    ),
                    onChanged: (text) {
                      context.read<AddExercise>().getExercises(text);
                    },
                  ),
                ),
              ),

              // Exercise List
              Expanded(
                child: Consumer<AddExercise>(
                  builder: (context, addExercise, child) {
                    if (addExercise.result.isEmpty) {
                      return FadeInAnimation(
                        delay: Duration(milliseconds: 200),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ScaleAnimation(
                                duration: Duration(milliseconds: 600),
                                child: Container(
                                  padding: EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    color: AppTheme.surfaceDark,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.accentCyan.withOpacity(0.3),
                                        blurRadius: 30,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.search_off,
                                    size: 80,
                                    color: AppTheme.accentCyan,
                                  ),
                                ),
                              ),
                              SizedBox(height: 32),
                              Text(
                                "No exercises found",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                "Try a different search or\ncreate a custom exercise",
                                style: TextStyle(fontSize: 16, color: Colors.white60),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 32),
                              ScaleAnimation(
                                delay: Duration(milliseconds: 400),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: AppTheme.greenGradient,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.accentGreen.withOpacity(0.4),
                                        blurRadius: 20,
                                        offset: Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(16),
                                      onTap: () {
                                        _showCreateExerciseDialog(
                                            context, searchController.text);
                                      },
                                      child: Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.add_circle, color: Colors.white),
                                            SizedBox(width: 12),
                                            Text(
                                              "Create Custom Exercise",
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
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: addExercise.result.length,
                      itemBuilder: (context, index) {
                        final exercise = addExercise.result[index];
                        final latestWorkout =
                            Provider.of<WorkoutProvider>(context, listen: false)
                                .latestWorkout;

                        // Get color based on muscle group
                        final muscleGroupColors = {
                          'Chest': AppTheme.accentPurple,
                          'Back': AppTheme.accentBlue,
                          'Legs': AppTheme.accentGreen,
                          'Shoulders': AppTheme.accentOrange,
                          'Biceps': AppTheme.accentCyan,
                          'Triceps': AppTheme.accentPink,
                          'Abs': AppTheme.accentPurple,
                          'Cardio': AppTheme.accentGreen,
                        };

                        final color = muscleGroupColors[exercise.muscleGroup] ??
                                     AppTheme.accentPurple;

                        return FadeInAnimation(
                          delay: Duration(milliseconds: 50 * index),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: color.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  if (latestWorkout != null) {
                                    Provider.of<WorkoutProvider>(context, listen: false)
                                        .addExerciseToWorkout(
                                      latestWorkout.id,
                                      exercise.name,
                                      exercise.muscleGroup,
                                    );
                                    context.go('/create_workout');
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('No workout added.'),
                                        backgroundColor: AppTheme.accentPink,
                                      ),
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      // Icon
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [color, color.withOpacity(0.7)],
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.fitness_center,
                                          color: Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      // Text
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              exercise.name,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              exercise.muscleGroup,
                                              style: TextStyle(
                                                color: color,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Custom badge
                                      if (exercise.isCustom)
                                        Container(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            gradient: AppTheme.blueGradient,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'Custom',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward_ios,
                                          color: Colors.white30, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ScaleAnimation(
        delay: Duration(milliseconds: 600),
        child: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.purpleGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accentPurple.withOpacity(0.5),
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              _showCreateExerciseDialog(context, '');
            },
            icon: Icon(Icons.add_circle_outline, color: Colors.white),
            label: Text(
              "Create Custom",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateExerciseDialog(BuildContext context, String initialName) {
    final nameController = TextEditingController(text: initialName);
    String selectedMuscleGroup = 'Chest';
    final exerciseService = ExerciseService();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ScaleAnimation(
              duration: Duration(milliseconds: 300),
              child: AlertDialog(
                backgroundColor: AppTheme.surfaceDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                title: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppTheme.purpleGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.add_circle, color: Colors.white),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Create Custom Exercise',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Exercise Name',
                        labelStyle: TextStyle(color: Colors.white70),
                        hintText: 'e.g., Cable Flyes',
                        hintStyle: TextStyle(color: Colors.white38),
                        prefixIcon: Icon(Icons.fitness_center, color: AppTheme.accentPurple),
                      ),
                      autofocus: initialName.isEmpty,
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      value: selectedMuscleGroup,
                      dropdownColor: AppTheme.surfaceDark,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Muscle Group',
                        labelStyle: TextStyle(color: Colors.white70),
                        prefixIcon: Icon(Icons.category, color: AppTheme.accentCyan),
                      ),
                      items: exerciseService
                          .getMuscleGroups()
                          .map((group) => DropdownMenuItem(
                                value: group,
                                child: Text(group),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMuscleGroup = value!;
                        });
                      },
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: Text('Cancel', style: TextStyle(color: Colors.white60)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.greenGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () async {
                        final name = nameController.text.trim();
                        if (name.isNotEmpty) {
                          // Add to custom exercises
                          await context
                              .read<AddExercise>()
                              .addCustomExercise(name, selectedMuscleGroup);

                          // Add to current workout
                          final latestWorkout =
                              context.read<WorkoutProvider>().latestWorkout;
                          if (latestWorkout != null) {
                            context.read<WorkoutProvider>().addExerciseToWorkout(
                                  latestWorkout.id,
                                  name,
                                  selectedMuscleGroup,
                                );
                          }

                          Navigator.of(dialogContext).pop();
                          context.go('/create_workout');
                        }
                      },
                      icon: Icon(Icons.check_circle, color: Colors.white),
                      label: Text(
                        'Create & Add',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
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
}
