import 'package:flutter/material.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:trainingapp/components/workout_tile.dart';

class OngoingWorkout extends StatelessWidget {
  const OngoingWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongoing Workout'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ListView med workout-tiles
          Expanded(
            child: Consumer<WorkoutProvider>(
              builder: (context, workoutProvider, child) {
                return ListView.builder(
                  itemCount: workoutProvider.workouts.length,
                  itemBuilder: (context, index) {
                    return WorkoutTile(workoutIndex: index);
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
                child: Center(child: Text('JAA') // TIMER-KNAPP,
                    ),
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
          )
        ],
      ),
    );
  }
}
