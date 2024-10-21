import 'package:flutter/material.dart';
import 'package:trainingapp/states/screen_index_provider.dart';

class OngoingWorkout extends StatelessWidget {
  const OngoingWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongoing Workout'),
      ),
    );
  }
}
