import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:trainingapp/screens/finished_workout.dart';

class HistoryTile extends StatelessWidget {
  final String date;
  final String workoutName;
  final String duration;
  final String weather;
  final String temperature;
  final String workoutID;

  const HistoryTile({
    Key? key,
    required this.date,
    required this.workoutName,
    required this.duration,
    required this.weather,
    required this.temperature,
    required this.workoutID,
  }) : super(key: key);

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/cloudy.json';
      case 'mist':
      case 'fog':
      case 'haze':
        return 'assets/misty.json';
      case 'rain':
      case 'drizzle':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/rainy_thunder.json';
      case 'snow':
        return 'assets/snowy.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/finished_workout', extra: workoutID);
        print('TRYCKTE PÅ: $workoutID');
      },
      child: Card(
        color: Colors.lightBlue[50],
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 5.0),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: ListTile(
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workoutName,
                  style: TextStyle(color: Colors.blueGrey[800], fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'Duration: $duration',
                  style: TextStyle(color: Colors.blueGrey[600], fontSize: 14),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Lottie.asset(getWeatherAnimation(weather)),
                ),
                Text(
                  '$temperature°C',
                  style: TextStyle(color: Colors.blueGrey[800]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
