class WorkoutSet {
  int setNumber;
  double weight;
  int reps;

  WorkoutSet({
    required this.setNumber,
    this.weight = 0.0,
    this.reps = 0,
  });
}

class Workout {
  String exerciseName;
  List<WorkoutSet> sets;

  Workout({required this.exerciseName, required this.sets});
}
