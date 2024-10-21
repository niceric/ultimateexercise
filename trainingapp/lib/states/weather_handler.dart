import 'package:flutter/material.dart';
import 'package:trainingapp/models/weather_model.dart';
import 'package:trainingapp/services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  Weather? _weather;
  Weather? get weather => _weather;

  bool _loading = false;
  bool get loading => _loading;

  final WeatherService _weatherService;

  WeatherProvider(this._weatherService);

  Future<void> fetchWeather() async {
    _loading = true;
    notifyListeners();

    try {
      String cityName = await _weatherService.getCurrentCity();
      final weatherData = await _weatherService.getWeather();
      _weather = Weather.fromJson(weatherData, cityName);
    } catch (e) {
      print(e);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
