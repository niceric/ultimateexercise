import 'package:flutter/material.dart';
import 'package:trainingapp/components/bottom_appbar.dart';

class FinishedWorkout extends StatelessWidget {
  const FinishedWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finished Workout'),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomMenu(),
    );
  }
}
