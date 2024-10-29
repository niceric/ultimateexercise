import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:trainingapp/models/workout_model.dart';

class ExerciseTile extends StatelessWidget {
  final String workoutID;
  final int exerciseIndex;
  // being created 1, ongoing 2, finished 3
  final int workoutStatus;

  ExerciseTile(
      {required this.workoutID,
      required this.exerciseIndex,
      required this.workoutStatus});

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, workoutProvider, child) {
        // Find the workout with the matching ID
        final workout = workoutProvider.getWorkoutById(workoutID);
        final exercise = workout.exercises[exerciseIndex];

        return Card(
          color: Colors.lightBlue[50],
          elevation: 4,
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.exerciseName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                // Display each set's weight and reps
                Column(
                  children: exercise.sets.asMap().entries.map((entry) {
                    int setIndex = entry.key;
                    WorkoutSet set = entry.value;

                    TextEditingController weightController =
                        TextEditingController(
                      text: set.weight.toString(),
                    );
                    TextEditingController repsController =
                        TextEditingController(
                      text: set.reps.toString(),
                    );

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Text('Set ${set.setNumber}'), // Set number
                          SizedBox(width: 10),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Weight TextField
                                Flexible(
                                  child: TextField(
                                    controller: weightController,
                                    decoration: InputDecoration(
                                      labelText: 'Weight',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      double weight =
                                          double.tryParse(value) ?? 1.0;
                                      workoutProvider.updateSet(
                                          workoutID,
                                          exerciseIndex,
                                          setIndex,
                                          set.reps,
                                          weight);
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                // Reps TextField
                                Flexible(
                                  child: TextField(
                                    controller: repsController,
                                    decoration: InputDecoration(
                                      labelText: 'Reps',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      int reps = int.tryParse(value) ?? 1;
                                      workoutProvider.updateSet(
                                          workoutID,
                                          exerciseIndex,
                                          setIndex,
                                          reps,
                                          set.weight);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: 10),

                // "+" button to add a new set
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: workout.isFinished
                          ? Text('')
                          : IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                exercise.sets.length;
                                print(
                                    'THIS IS THE EXERCISE INDEX: $exerciseIndex'
                                    'THIS IS THE SETAMOUNT: ${exercise.sets.length}');

                                exercise.sets.length != 1
                                    ? exercise.sets.removeLast()
                                    : workout.exercises.removeAt(exerciseIndex);
                                workoutProvider.updateSetList();
                              },
                            ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: workout.isFinished
                          ? Text('')
                          : IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                workoutProvider.addSetToExercise(
                                    workoutID,
                                    exerciseIndex,
                                    1,
                                    1); // Adds a new empty set
                              },
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
