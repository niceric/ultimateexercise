import 'package:flutter/material.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:trainingapp/components/exercise_tile.dart';
import 'package:trainingapp/states/stopwatch-handler.dart';

class FinishedWorkout extends StatelessWidget {
  final String? workoutID;

  FinishedWorkout({Key? key, String? this.workoutID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.go('/history'),
        ),
        title: Text('Finished Workout'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ListView med workout-tiles
          Expanded(
            child: Consumer<WorkoutProvider>(
              builder: (context, workoutProvider, child) {
                String? workoutID = GoRouterState.of(context).extra as String;
                int exerciseCount =
                    workoutProvider.getWorkoutById(workoutID).exercises.length;
                return ListView.builder(
                  itemCount: exerciseCount,
                  itemBuilder: (context, index) {
                    return ExerciseTile(
                      workoutID: workoutID,
                      exerciseIndex: index,
                      workoutStatus: 2,
                    );
                  },
                );
              },
            ),
          ),
          Divider(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 100, right: 100),

                // ),
                // IconButton(
                //   icon: Icon(Icons.add),
                //   onPressed: () => {
                //     context.go('/add_exercise')

                // Lägg till en ny övning
                // Koden endan lägger till en övning, placeholder namn - populeras i ListView i denna screen
                // Provider.of<WorkoutProvider>(context, listen: false)
                //     .addWorkout("New Exercise"); // Placeholder namn
                // },
              ),
            ],
          ),
        ],
      ),
      // bottomNavigationBar: TimerWidget(),
    );
  }
}
