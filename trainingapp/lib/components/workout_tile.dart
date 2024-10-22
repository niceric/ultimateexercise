// takes the workout model data and creates workout tiles to populate the create workout, ongoing workout screen, finished workout screens
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:trainingapp/models/workout_model.dart';

class WorkoutTile extends StatelessWidget {
  final int workoutIndex;

  WorkoutTile({required this.workoutIndex});

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, workoutProvider, child) {
        final workout = workoutProvider.workouts[workoutIndex];
        return Card(
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titel med övningens namn
                Text(
                  workout.exerciseName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                // Listan med sets
                Column(
                  children: workout.sets.asMap().entries.map((entry) {
                    int setIndex = entry.key;
                    WorkoutSet set = entry.value;

                    // TextEditingController för vikt och reps
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
                          // Set-nummer
                          Text(set.setNumber.toString()),
                          SizedBox(width: 10),
                          // Vikt och Reps textfält
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Vikt TextField
                                Flexible(
                                  child: TextField(
                                    controller: weightController,
                                    decoration: InputDecoration(
                                      labelText: 'Vikt',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      double weight =
                                          double.tryParse(value) ?? 0.0;
                                      workoutProvider.updateSet(workoutIndex,
                                          setIndex, weight, set.reps);
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
                                      int reps = int.tryParse(value) ?? 0;
                                      workoutProvider.updateSet(workoutIndex,
                                          setIndex, set.weight, reps);
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
                // "+" knapp för att lägga till ett nytt set
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      workoutProvider.addSetToWorkout(workoutIndex);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
