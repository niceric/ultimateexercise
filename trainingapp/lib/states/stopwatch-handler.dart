import 'dart:async';
import 'package:flutter/material.dart';

class StopwatchProvider extends ChangeNotifier {
  Stopwatch _stopwatch = Stopwatch();
  bool _isRunning = false;
  Timer? _timer;

  bool get isRunning => _isRunning;

  String get time {
    final seconds = _stopwatch.elapsed.inSeconds;
    final minutes = seconds ~/ 60;
    final hours = minutes ~/ 60;
    return '${hours.toString().padLeft(1, '0')}:${(minutes % 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  void startStopwatch() {
    _stopwatch.start();
    _isRunning = true;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      notifyListeners();
    });
  }

  void pauseStopwatch() {
    _stopwatch.stop();
    _isRunning = false;
    notifyListeners();
  }

  void resetStopwatch() {
    _stopwatch.reset();
    notifyListeners();
  }
}
