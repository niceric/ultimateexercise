class Weather {
  final String cityName;
  final double temperatureCelsius;
  final String mainCondition;

  Weather(
      {required this.cityName,
      required this.temperatureCelsius,
      required this.mainCondition});

  factory Weather.fromJson(Map<String, dynamic> json, String cityName) {
    return Weather(
        cityName: cityName,
        temperatureCelsius: json['main']['temp'].toDouble(),
        mainCondition: json['weather'][0]['main']);
  }
}
