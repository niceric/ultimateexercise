import 'package:flutter/material.dart';
import '../components/history_tile.dart';
import 'package:trainingapp/components/bottom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:trainingapp/models/workout_model.dart';

class Historypage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Historik'),
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          return ListView.builder(
            itemCount: workoutProvider.workouts.length,
            itemBuilder: (context, index) {
              final workout = workoutProvider.workouts[index];
              return HistoryTile(
                date: workout.workoutDate ??
                    '', // '${workout.date.month}-${workout.date.day}',
                // ersätt med namn för passet inte övningarna
                workoutName: workout.workoutName,
                duration: workout.time,
                weather: workout.weather[1],
                temperature: workout.weather[0],
                workoutID: workout.id,
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}

// Consumer<WorkoutProvider>(
//               builder: (context, workoutProvider, child) {
//                 return ListView.builder(
//                   itemCount: workoutProvider.workouts.length,
//                   itemBuilder: (context, index) {
//                     return HistoryTile(
//                       date: 'Ons 9',
//                       workoutName: 'Rygg/Biceps',
//                       duration: '1h 15min',
//                       weatherIcon: 'sun',
//                       temperature: '20°C',
//                           );
//                   },
//                 );
//               },
//             ),
