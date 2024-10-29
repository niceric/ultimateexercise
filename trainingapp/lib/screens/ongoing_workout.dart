import 'package:flutter/material.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:trainingapp/components/exercise_tile.dart';
import 'package:trainingapp/states/stopwatch-handler.dart';

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
          Expanded(
            child: Consumer<WorkoutProvider>(
              builder: (context, workoutProvider, child) {
                return ListView.builder(
                  itemCount: workoutProvider.workouts.last.exercises.length,
                  itemBuilder: (context, index) {
                    return ExerciseTile(
                      workoutID: workoutProvider.workouts.last.id,
                      exerciseIndex: index,
                      workoutStatus: 2,
                    );
                  },
                );
              },
            ),
          ),
          const Divider(
            height: 10,
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 100, right: 100),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: TimerWidget(),
    );
  }
}

class TimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final time = context.watch<StopwatchProvider>().time;
    final isRunning = context.watch<StopwatchProvider>().isRunning;
    final workoutID = context.watch<WorkoutProvider>().workouts.last.id;
    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 125,
              width: 150,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isRunning
                      ? const Color.fromARGB(255, 42, 211, 48)
                      : const Color.fromARGB(255, 255, 230, 0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      if (isRunning) {
                        context.read<StopwatchProvider>().pauseStopwatch();
                      } else {
                        context.read<StopwatchProvider>().startStopwatch();
                      }
                    },
                    icon: Icon(
                      isRunning ? Icons.pause : Icons.play_arrow,
                      color: Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      time,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  const Icon(Icons.timer),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton(
              onPressed: () {
                context.read<StopwatchProvider>().pauseStopwatch();
                _showEndWorkoutDialog(context, time, workoutID);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 17),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Finish",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _showEndWorkoutDialog(
    BuildContext context, String time, String workoutID) {
  showDialog(
    context:
        context, //Context används för att placerar dialogen rätt i i widgetträdet
    builder: (BuildContext context) {
      //Lokal context för att bygga popuprutans innehåll
      DateTime today = DateTime.now();

      return AlertDialog(
        title: const Text("Finish workout?"),
        content: Text("Total time: $time"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Stänger dialogrutan
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              context.read<StopwatchProvider>().pauseStopwatch();
              print(
                  "Workout finished. Total time: $time"); //Lägg till kod som hanterar ett avslutat pass
              Navigator.of(context).pop();
              context.read<WorkoutProvider>().updateWorkoutStatus(workoutID);
              context.read<WorkoutProvider>().setWorkoutTime(time, workoutID);
              context.read<StopwatchProvider>().resetStopwatch();
              context
                  .read<WorkoutProvider>()
                  .addTrainingDay(today); // Lägger till dagens datum
              context.go('/finished_workout',
                  extra: workoutID); // Stänger dialogrutan
            },
            child: const Text("Yes"),
          ),
        ],
      );
    },
  );
}
