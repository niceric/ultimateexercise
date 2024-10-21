import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trainingapp/screens/history.dart';
import 'package:trainingapp/screens/home.dart';

class ScreenIndexProvider extends ChangeNotifier {
  int screenIndex = 0;
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
    if (index == 0) context.go('/');
    if (index == 1) context.go('/history');
  }

  final GoRouter _router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) {
            return const homePage();
          },
          routes: <RouteBase>[
            GoRoute(
              path: 'history',
              builder: (BuildContext context, GoRouterState state) {
                return Historypage();
              },
            )
          ])
    ],
  );
}
