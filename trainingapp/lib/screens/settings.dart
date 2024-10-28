import 'package:flutter/material.dart';
import '../components/history_tile.dart';
import 'package:trainingapp/components/bottom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/states/workout_handler.dart';
import 'package:trainingapp/models/workout_model.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inputWeight = TextEditingController();
    final inputUserName = TextEditingController();

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
              Card(
                color: Colors.lightBlue[50],
                elevation: 4,
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: TextField(
                            onChanged: (value) {
                              context
                                  .read<WorkoutProvider>()
                                  .setUserWeight(inputWeight.text);
                            },
                            decoration:
                                InputDecoration(hintText: "Enter bodyweight"),
                            controller: inputWeight),
                      ),
                      Container(
                        child: Column(
                          children: [
                            TextField(
                                decoration:
                                    InputDecoration(hintText: "Enter username"),
                                onChanged: (value) {
                                  context
                                      .read<WorkoutProvider>()
                                      .setUserName(inputUserName.text);
                                },
                                controller: inputUserName)
                          ],
                        ),
                      ),
                      Text('Your bodyweight: '),
                      Text(
                          '${context.watch<WorkoutProvider>().userBodyWeight.toString()} kg'),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}
