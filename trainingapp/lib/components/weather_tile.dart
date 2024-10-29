import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trainingapp/states/weather_handler.dart';

class WeatherTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        // Delay fetchWeather until the build is done
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (weatherProvider.weather == null && !weatherProvider.loading) {
            weatherProvider.fetchWeather();
          }
        });

        return Column(
          children: [
            if (weatherProvider.loading)
              Text('Loading weather data...')
            else if (weatherProvider.weather != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(weatherProvider.weather!.cityName),
                  Text(
                      '${weatherProvider.weather!.temperatureCelsius.round()}°C'),
                  Text(weatherProvider.weather!.mainCondition),
                ],
              )
            else
              Text('Could not load weather data'),
          ],
        );
      },
    );
  }
}
