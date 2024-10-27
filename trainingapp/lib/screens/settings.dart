import 'package:flutter/material.dart';
import '../components/history_tile.dart';
import 'package:trainingapp/components/bottom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:trainingapp/models/workout_model.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text('Settings'),
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, workoutProvider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Your bodyweight: '),
                  Text(
                      '${context.watch<WorkoutProvider>().userBodyWeight.toString()} kg'),
                ],
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}
