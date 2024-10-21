import 'dart:convert';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

//

class WeatherService {
  static const API_URL = 'https://api.openweathermap.org/data/2.5/weather';

  final String apiKey;

  WeatherService(this.apiKey);

  Future<Map<String, dynamic>> getWeather() async {
    Position position = await Geolocator.getCurrentPosition();
    final lat = position.latitude;
    final lon = position.longitude;

    final response = await http.get(
        Uri.parse('$API_URL?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      print('Error: ${response.body}');
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
    Position position = await Geolocator.getCurrentPosition();

    // convert the location to a list o placemark objects
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // extract city name from first placemark
    String? city = placemarks[0].subLocality;
    String? subLocality = placemarks[0].subLocality;
    String? adminArea = placemarks[0].administrativeArea;

    print('Location details: $subLocality, $city, $adminArea');

    return city ?? 'Could not load your location';
  }
}
