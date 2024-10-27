import 'package:flutter/material.dart';
import 'package:trainingapp/models/weather_model.dart';
import 'package:trainingapp/states/weather_handler.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:trainingapp/components/exercise_tile.dart';
import '../services/weather_service.dart';

class CreateWorkout extends StatelessWidget {
  CreateWorkout({super.key});

  final controller = TextEditingController();
  final now = DateTime.now();

  // .read<WorkoutProvider>()
  // .addWorkout(controller.text, 'TID', 'VÄDER');

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    return Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   print('HIT DÅ?');
      //   context.read<WorkoutProvider>().addWorkout('TEST', 'TID', 'VÄDER');
      // });

      context.read<WorkoutProvider>().addWorkout(
          'Workout of the day', '${now.year}-${now.month}-${now.day}', 'VÄDER');
      //
      return Scaffold(
        appBar: AppBar(
          title: Text('Create Workout'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Card(
                color: Colors.lightBlue[50],
                elevation: 4,
                margin: EdgeInsets.all(8.0),
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: controller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText:
                                    workoutProvider.workouts.last.workoutName ==
                                            'Workout of the day'
                                        ? 'The name of the workout'
                                        : workoutProvider
                                            .workouts.last.workoutName),
                            onChanged: (value) => {
                              context.read<WorkoutProvider>().setWorkoutName(
                                  controller.text,
                                  workoutProvider.workouts.last.id)
                            },
                          ),
                        ]))),
            // Container(
            //   height: 90,
            //   decoration: BoxDecoration(
            //       color: Colors.lightBlue[50],
            //       borderRadius: BorderRadius.circular(5),
            //       border: Border.all(color: Colors.black87, width: 0.2),
            //       boxShadow: [
            //         BoxShadow(
            //             color: Color.fromARGB(255, 0, 0, 0),
            //             spreadRadius: 0.5,
            //             blurRadius: 2,
            //             offset: Offset.fromDirection(0.8, 3)),
            //       ]),
            //   padding: EdgeInsets.all(16),
            //   margin: EdgeInsets.all(20),
            //   child: TextField(
            //     controller: controller,
            //     decoration: InputDecoration(
            //         border: OutlineInputBorder(),
            //         hintText: workoutProvider.workouts.last.workoutName ==
            //                 'Workout of the day'
            //             ? 'The name of the workout'
            //             : workoutProvider.workouts.last.workoutName),
            //     onChanged: (value) => {
            //       context.read<WorkoutProvider>().setWorkoutName(
            //           controller.text, workoutProvider.workouts.last.id)
            //     },
            //   ),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         context
            //             .read<WorkoutProvider>()
            //             .addWorkout(controller.text, 'TID', 'VÄDER');
            //         controller.clear();
            //       },
            //       child: Row(
            //         children: [
            //           Icon(Icons.note_add),
            //           Text('ADD'),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // ListView med workout-tiles
            Expanded(
              child: ListView.builder(
                itemCount: workoutProvider.workouts.isEmpty
                    ? 0
                    : workoutProvider.workouts.last.exercises.length,
                itemBuilder: (context, index) {
                  return ExerciseTile(
                    workoutID: workoutProvider.workouts.last.id,
                    exerciseIndex: index,
                    workoutStatus: 1,
                  );
                },
              ),
            ),
            IconButton(
                onPressed: () {
                  workoutProvider
                      .updateWorkoutStatus(workoutProvider.workouts.last.id);
                },
                icon: Icon(Icons.abc_outlined)),

            Divider(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 100, right: 100),
                  child: Center(
                    child: TextButton(
                      child: Text('START WORKOUT'),
                      onPressed: () => {
                        weatherProvider.fetchWeather(),
                        // ['9', 'snow'],
                        // DEBBUGING - API DOWN???
                        workoutProvider.setWorkoutWeather([
                          '${weatherProvider.weather!.temperatureCelsius.round()}',
                          weatherProvider.weather!.mainCondition,
                        ], workoutProvider.workouts.last.id),
                        context.go('/ongoing_workout')
                      },
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => {
                    context.go('/add_exercise')

                    // Lägg till en ny övning
                    // Koden endan lägger till en övning, placeholder namn - populeras i ListView i denna screen
                    // Provider.of<WorkoutProvider>(context, listen: false)
                    //     .addWorkout("New Exercise"); // Placeholder namn
                  },
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
