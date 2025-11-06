import 'package:flutter/material.dart';
import 'package:trainingapp/components/modern_bottom_nav.dart';
import 'package:trainingapp/screens/modern_home.dart';
import 'package:trainingapp/screens/modern_history.dart';
import 'package:trainingapp/screens/modern_statistics.dart';
import 'package:trainingapp/screens/modern_profile.dart';
import 'package:trainingapp/screens/workout_setup_screen.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/states/workout_handler.dart';

class MainApp extends StatefulWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _currentIndex = 0;

  void _onNavigate(int index) {
    if (index == 2) {
      // Create workout button - navigate to workout setup
      final provider = Provider.of<WorkoutProvider>(context, listen: false);
      provider.addWorkout();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutSetupScreen(
            workout: provider.latestWorkout!,
          ),
        ),
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      ModernHome(onNavigate: _onNavigate),
      ModernHistory(),
      SizedBox(), // Placeholder for center button
      ModernStatistics(),
      ModernProfile(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: ModernBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavigate,
      ),
    );
  }
}
