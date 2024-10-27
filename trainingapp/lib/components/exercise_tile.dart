// // takes the workout model data and creates workout tiles to populate the create workout, ongoing workout screen, finished workout screens
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:trainingapp/models/workout_model.dart';

// class ExerciseTile extends StatelessWidget {
//   final String workoutID;
//   final int exerciseIndex;

//   ExerciseTile({required this.workoutID, required this.exerciseIndex});

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<WorkoutProvider>(
//       builder: (context, workoutProvider, child) {
//         // final workout = workoutProvider.workouts[workoutIndex].exercises;
//         final workout = workoutProvider.workouts.firstWhere(
//           (workout) => workout.id == workoutID,
//           orElse: () => Workout(
//             workoutName: "Unnamed Workout",
//             date: DateTime.now(),
//             time: "00:00",
//             weather: "Unknown",
//             exercises: [],
//           ), // Provide a default workout if not found
//         );
//         // Get the exercise using exerciseIndex if it exists
//         final exercise = (exerciseIndex < workout.exercises.length)
//             ? workout.exercises[exerciseIndex]
//             : Exercise(
//                 exerciseName: 'Ingen övning tillagd',
//                 muscleGroup: '',
//                 sets: []);
//         ;
//         return Card(
//           color: Colors.lightBlue[50],
//           elevation: 4,
//           margin: EdgeInsets.all(8.0),
//           child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Titel med övningens namn
//                     Text(
//                       exercise.exerciseName,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     Column(
//                   children: exercise.sets.asMap().entries.map((entry) {
//                     int setIndex = entry.key;
//                     WorkoutSet set = entry.value;

//                     TextEditingController weightController = TextEditingController(
//                       text: set.weight.toString(),
//                     );
//                     TextEditingController repsController = TextEditingController(
//                       text: set.reps.toString(),
//                     );

//                     return Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Row(
//                         children: [
//                           Text('Set ${set.setNumber}'), // Set number
//                           SizedBox(width: 10),
//                           Expanded(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 // Weight TextField
//                                 Flexible(
//                                   child: TextField(
//                                     controller: weightController,
//                                     decoration: InputDecoration(
//                                       labelText: 'Weight',
//                                       border: OutlineInputBorder(),
//                                     ),
//                                     keyboardType: TextInputType.number,
//                                     onChanged: (value) {
//                                       double weight = double.tryParse(value) ?? 0.0;
//                                       workoutProvider.updateSet(
//                                           workoutID, exerciseIndex, setIndex, set.reps, weight);
//                                     },
//                                   ),
//                                 ),
//                                 SizedBox(width: 10),
//                                 // Reps TextField
//                                 Flexible(
//                                   child: TextField(
//                                     controller: repsController,
//                                     decoration: InputDecoration(
//                                       labelText: 'Reps',
//                                       border: OutlineInputBorder(),
//                                     ),
//                                     keyboardType: TextInputType.number,
//                                     onChanged: (value) {
//                                       int reps = int.tryParse(value) ?? 0;
//                                       workoutProvider.updateSet(
//                                           workoutID, exerciseIndex, setIndex, reps, set.weight);
//                                     }],
//                                   ),
//                                 ),
//                               ]
//                   ),)},
//         );
//       },
//     );
//   }
// }

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

        // // Retrieve the current exercise using the exerciseIndex
        // final exercise = workout.exercises[exerciseIndex];
        // final workout = workoutProvider.workouts.firstWhere(
        //   (workout) => workout.id == workoutID,
        //   orElse: () => Workout(
        //     workoutName: "Unnamed Workout",
        //     date: DateTime.now(),
        //     time: "00:00",
        //     weather: "Unknown",
        //     exercises: [],
        //   ), // Provide a default workout if not found
        // );
        // Get the exercise using exerciseIndex if it exists
        final exercise = workout.exercises[exerciseIndex];
        // final exercise = (exerciseIndex < workout.exercises.length)
        //     ? workout.exercises[exerciseIndex]
        //     : Exercise(
        //         exerciseName: 'Ingen övning tillagd',
        //         muscleGroup: '',
        //       );
        // ;

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
                                          double.tryParse(value) ?? 0.0;
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
                                      int reps = int.tryParse(value) ?? 0;
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

                Align(
                  alignment: Alignment.centerRight,
                  child: workout.isFinished
                      ? Text('')
                      : IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            workoutProvider.addSetToExercise(workoutID,
                                exerciseIndex, 0, 0); // Adds a new empty set
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
