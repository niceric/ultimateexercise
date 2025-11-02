import 'package:flutter/material.dart';
import 'package:trainingapp/components/bottom_appbar.dart';
import 'package:trainingapp/models/local_exercise.dart';
import 'package:trainingapp/services/exercise_service.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:trainingapp/states/workout_handler.dart';

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
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.go('/create_workout'),
        ),
        title: Text('Add Exercise'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Search for exercise...",
                    suffixIcon: Icon(Icons.search)),
                onChanged: (text) {
                  context.read<AddExercise>().getExercises(text);
                }),
          ),
          Expanded(
            child: Consumer<AddExercise>(
              builder: (context, addExercise, child) {
                if (addExercise.result.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "No exercises found.",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Try a different search or create custom exercise below.",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            _showCreateExerciseDialog(context, searchController.text);
                          },
                          icon: Icon(Icons.add),
                          label: Text("Create Custom Exercise"),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: addExercise.result.length,
                  itemBuilder: (context, index) {
                    final exercise = addExercise.result[index];
                    final latestWorkout =
                        Provider.of<WorkoutProvider>(context, listen: false)
                            .latestWorkout;
                    return ListTile(
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
                            SnackBar(content: Text('No workout added.')),
                          );
                        }
                      },
                      title: Text(exercise.name),
                      subtitle: Text(exercise.muscleGroup),
                      leading: CircleAvatar(
                        child: Text(
                          exercise.name[0].toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      trailing: exercise.isCustom
                          ? Chip(
                              label: Text('Custom',
                                  style: TextStyle(fontSize: 10)),
                              backgroundColor: Colors.blue.shade100,
                              padding: EdgeInsets.all(2),
                            )
                          : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showCreateExerciseDialog(context, '');
        },
        icon: Icon(Icons.add),
        label: Text("Create Custom"),
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
            return AlertDialog(
              title: Text('Create Custom Exercise'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Exercise Name',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., Cable Flyes',
                    ),
                    autofocus: initialName.isEmpty,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedMuscleGroup,
                    decoration: InputDecoration(
                      labelText: 'Muscle Group',
                      border: OutlineInputBorder(),
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
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    if (name.isNotEmpty) {
                      // Add to custom exercises
                      await context
                          .read<AddExercise>()
                          .addCustomExercise(name, selectedMuscleGroup);

                      // Add to current workout
                      final latestWorkout = context
                          .read<WorkoutProvider>()
                          .latestWorkout;
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
                  child: Text('Create & Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
