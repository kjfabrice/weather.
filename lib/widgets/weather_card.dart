import 'package:flutter/material.dart';
import 'package:weather_app/models/city.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({required this.city, required this.cityIndex, super.key});

  final City city;
  final int cityIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = city.icon;
    final index = icon.indexOf('weather', 20);
    final iconPath = icon.substring(index + 8);

    return Card(
      color: theme.colorScheme.secondary,
      child: ListTile(
        title: cityIndex == 0
            ? Row(
                children: [
                  Text(
                    city.name,
                    style: theme.textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                    ),
                  ),
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                  )
                ],
              )
            : Text(
                city.name,
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontSize: 20,
                ),
              ),
        subtitle: Text(
          '${city.region}, ${city.country}\n${city.maxTemp.ceil()}° / ${city.minTemp.ceil()}°',
          style: theme.textTheme.bodyLarge!.copyWith(fontSize: 12),
        ),
        trailing: SizedBox(
          width: 120,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'assets/weather/$iconPath',
                width: 60,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8),
              Text(
                '${city.currentTemp.ceil()}°',
                style: theme.textTheme.bodyLarge!.copyWith(fontSize: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
