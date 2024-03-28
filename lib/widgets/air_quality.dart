import 'package:flutter/material.dart';

import 'package:weather_app/models/weather.dart';

class AirQuality extends StatelessWidget {
  const AirQuality({super.key, required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    const valueColor = Colors.green;
    const labelColor = Colors.white54;
    const double valueFontSize = 25;
    const double labelFontSize = 12;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              '${weather.pm2_5}',
              style:
                  const TextStyle(color: valueColor, fontSize: valueFontSize),
            ),
            const Text(
              'PM2.5',
              style: TextStyle(color: labelColor, fontSize: labelFontSize),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              '${weather.pm10}',
              style:
                  const TextStyle(color: valueColor, fontSize: valueFontSize),
            ),
            const Text(
              'PM10',
              style: TextStyle(color: labelColor, fontSize: labelFontSize),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              '${weather.so2}',
              style:
                  const TextStyle(color: valueColor, fontSize: valueFontSize),
            ),
            const Text(
              'SO2',
              style: TextStyle(color: labelColor, fontSize: labelFontSize),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              '${weather.no2}',
              style:
                  const TextStyle(color: valueColor, fontSize: valueFontSize),
            ),
            const Text(
              'NO2',
              style: TextStyle(color: labelColor, fontSize: labelFontSize),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              '${weather.o3}',
              style:
                  const TextStyle(color: valueColor, fontSize: valueFontSize),
            ),
            const Text(
              'O3',
              style: TextStyle(color: labelColor, fontSize: labelFontSize),
            ),
          ],
        ),
        Column(
          children: [
            Text(
              '${weather.co}',
              style:
                  const TextStyle(color: valueColor, fontSize: valueFontSize),
            ),
            const Text(
              'CO',
              style: TextStyle(color: labelColor, fontSize: labelFontSize),
            ),
          ],
        )
      ],
    );
  }
}
