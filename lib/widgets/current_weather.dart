import 'package:flutter/material.dart';

import 'package:weather_app/models/weather.dart';
import 'package:weather_app/screens/aqi_screen.dart';

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({super.key, required this.currentWeather});

  final Weather currentWeather;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = currentWeather.icon;
    final index = icon.indexOf('weather', 20);
    final iconPath = icon.substring(index + 8);

    return Column(
      children: [
        Image.asset(
          'assets/weather/$iconPath',
          width: 150,
          height: 140,
          fit: BoxFit.cover,
        ),
        Text(
          '${currentWeather.currentTemp.ceil()}°',
          style: theme.textTheme.bodyLarge!.copyWith(
            fontSize: 75,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'But feels like ${currentWeather.feelsLike.ceil()}°',
          style: theme.textTheme.bodyLarge!.copyWith(
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          currentWeather.conditionText,
          style: theme.textTheme.bodyLarge!.copyWith(
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 17),
        Text(
          'Wind',
          style: theme.textTheme.bodyLarge!.copyWith(
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.air_rounded,
              size: 28,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Text(
              '${currentWeather.windSpeed} km/h',
              style: theme.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        FilledButton.icon(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => AqiScreen(weather: currentWeather),
            ));
          },
          label: Text('AQI  ${currentWeather.pm2_5.round()}'),
          icon: const Icon(Icons.eco),
        ),
      ],
    );
  }
}
