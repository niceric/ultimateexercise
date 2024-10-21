import 'package:flutter/material.dart';
import 'package:trainingapp/states/screen_index_provider.dart';
import 'package:provider/provider.dart';

class CreateWorkout extends StatelessWidget {
  const CreateWorkout({super.key});

  @override
  Widget build(BuildContext context) {
    final _screenindexprovider = Provider.of<ScreenIndexProvider>(context);
    int currentScreenIndex = _screenindexprovider.fetchCurrentScreenIndex;
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Workout'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    currentScreenIndex == 5;
                  },
                  icon: Icon(Icons.plus_one))
            ],
          )
        ],
      ),
    );
  }
}
