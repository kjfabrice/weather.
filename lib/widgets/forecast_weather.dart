import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:weather_app/models/forecast.dart';

class Forecastweather extends StatelessWidget {
  const Forecastweather({super.key, required this.forecastDay});

  final List forecastDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    DateFormat dateFormat = DateFormat.MMMEd();
    final forecastWeather =
        forecastDay.map((forecast) => Forecast.fromJSON(forecast));

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
      child: Column(
        children: forecastWeather.map((weather) {
          final icon = weather.icon;
          final index = icon.indexOf('weather', 20);
          final iconPath = icon.substring(index + 8);

          final DateTime date = DateTime.tryParse(weather.date)!;
          final formattedDate = dateFormat.format(date);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                formattedDate,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontSize: 16,
                ),
              ),
              Image.asset(
                'assets/weather/$iconPath',
                fit: BoxFit.cover,
              ),
              Text(
                '${weather.maxTemp.ceil()}° ${weather.minTemp.ceil()}°',
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontSize: 16,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
