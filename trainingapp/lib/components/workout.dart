// add workout class
// needs workout title, current weather, weight, time, date, exercise, reps, sets
//

class Workout {
  String? workoutName = '';
  String? currentWeather = '';
  int? weight;
  int? time;
  int? date;
  String exercise = '';
  int reps = 1;
  int sets = 1;

  Workout({
    required this.workoutName,
    required this.currentWeather,
    required this.weight,
    required this.time,
    required this.date,
    required this.exercise,
    required this.reps,
    required this.sets,
  });
}
