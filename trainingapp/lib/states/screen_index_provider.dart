import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trainingapp/screens/add_exercise.dart';
import 'package:trainingapp/screens/history.dart';
import 'package:trainingapp/screens/statistics.dart';
import 'package:trainingapp/screens/create_workout.dart';
import 'package:trainingapp/screens/finished_workout.dart';
import 'package:trainingapp/screens/home.dart';
import 'package:trainingapp/screens/ongoing_workout.dart';
import 'package:trainingapp/states/workout_handler.dart';

class ScreenIndexProvider extends ChangeNotifier {
  int screenIndex = 0;
  // String? workoutID = GoRouterState.of(context).extra! as String;
  int get fetchCurrentScreenIndex {
    return screenIndex;
  }

  GoRouter get fetchRouter {
    return _router;
  }

  void updateScreenIndex(int newIndex, BuildContext context) {
    screenIndex = newIndex;
    RouteScreen(screenIndex, context);
    notifyListeners();
  }

  void RouteScreen(index, BuildContext context) {
    if (index == 0) {
      context.go('/');
    } else if (index == 1) {
      context.go('/history');
    } else if (index == 2) {
      context.go('/create_workout');
    } else if (index == 3) {
      context.go('/statistics');
    } else if (index == 4) {
      context.go('/finished_workout');
    }
  }

  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const homePage(); //byt denna om ni vill ha en annan skräm här
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'history',
              builder: (BuildContext context, GoRouterState state) {
                return Historypage(); //byt denna om ni vill ha en annan skräm här
              },
            ),
            GoRoute(
              path: 'create_workout',
              builder: (BuildContext context, GoRouterState state) {
                return CreateWorkout(); //byt denna om ni vill ha en annan skräm här
              },
            ),
            GoRoute(
              path: 'statistics',
              builder: (BuildContext context, GoRouterState state) {
                return Statisticspage(); //byt denna om ni vill ha en annan skräm här
              },
            ),
            GoRoute(
              path: 'finished_workout',
              builder: (BuildContext context, GoRouterState state) {
                return FinishedWorkout(
                  workoutID: '',
                ); //byt denna om ni vill ha en annan skräm här
              },
            ),
            GoRoute(
              path: 'add_exercise',
              builder: (BuildContext context, GoRouterState state) {
                return AddExerciseSearchBar(); //byt denna om ni vill ha en annan skräm här
              },
            ),
            GoRoute(
              path: 'ongoing_workout',
              builder: (BuildContext context, GoRouterState state) {
                return OngoingWorkout(); //byt denna om ni vill ha en annan skräm här
              },
            ),
          ])
    ],
  );
}
