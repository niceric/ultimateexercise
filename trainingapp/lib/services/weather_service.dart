import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:trainingapp/models/weather_model.dart';
import 'package:http/http.dart';

class WeatherService {
  static const API_URL = 'https://api.openweathermap.org/data/3.0/onecall';
  static const API_URL_2 = 'https://api.openweathermap.org/data/2.5/weather';

  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('$API_URL_2?q=$cityName&appid=$apiKey&units=metric'))

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {

    // get permissoin from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // fetch current location
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings()
    ); 

    // convert the location to a list o placemark objects 

    // extract city name from first placemark 
  }
}
