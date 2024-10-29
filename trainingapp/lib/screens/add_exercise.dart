import 'package:flutter/material.dart';
import 'package:trainingapp/components/bottom_appbar.dart';
//import 'package:trainingapp/components/exercise_api.dart';
import 'package:trainingapp/models/exercise_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:trainingapp/states/workout_handler.dart';

class AddExercise extends ChangeNotifier {
  //const AddExercise({super.key});

  List<Exercise> result = [];
  String selectedWorkoutId = '';

  getExercises(String input) async {
    List<Exercise> results = await searchExercisesByName(input);
    result = results;
    notifyListeners();
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
                    hintText: "Search for exercise..."),
                onChanged: (text) {
                  context.read<AddExercise>().getExercises(text);
                }),
          ),
          Expanded(
            child: Consumer<AddExercise>(
              builder: (context, addExercise, child) {
                if (addExercise.result.isEmpty) {
                  return Center(
                    child: Text("No exercises found."),
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
                        // Kontrollera om latestWorkout inte är null
                        if (latestWorkout != null) {
                          Provider.of<WorkoutProvider>(context, listen: false)
                              .addExerciseToWorkout(
                            latestWorkout.id,
                            exercise.name ?? 'Not found',
                            exercise.bodyPart ?? 'Not found',
                          );
                          context.go('/create_workout');
                        } else {
                          // error handling
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Ingen workout tillagd.')),
                          );
                        }
                      },
                      title: Text(exercise.name ?? 'No Name'),
                      subtitle: Text(exercise.bodyPart ?? 'No Bodypart'),
                      leading:
                          exercise.gifUrl != null && exercise.gifUrl!.isNotEmpty
                              ? Image.network(exercise.gifUrl!)
                              : Icon(Icons.image_not_supported),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
