import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/widgets/air_quality.dart';

class AqiScreen extends StatelessWidget {
  const AqiScreen({super.key, required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String? risk;
    Color? riskColor;

    if (weather.gbDefraIndex >= 1 && weather.gbDefraIndex < 4) {
      risk = 'Low';
      riskColor = Colors.green;
    } else if (weather.gbDefraIndex >= 4 && weather.gbDefraIndex < 7) {
      risk = 'Moderate';
      riskColor = Colors.orange;
    } else if (weather.gbDefraIndex >= 7 && weather.gbDefraIndex < 10) {
      risk = 'High';
      riskColor = Colors.deepOrange;
    } else if (weather.gbDefraIndex == 10) {
      risk = 'Very High';
      riskColor = Colors.red;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // title: Text('data'),
        backgroundColor: Colors.black,
        foregroundColor: Theme.of(context).colorScheme.onInverseSurface,
        // surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Air Quality Index (AQI)',
                style: theme.textTheme.bodyLarge!.copyWith(
                  fontSize: 45,
                ),
              ),
              const SizedBox(height: 40),
              RichText(
                text: TextSpan(
                  text: '${weather.pm2_5.round()}\t\t',
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontSize: 50,
                    color: riskColor,
                  ),
                  children: [
                    TextSpan(
                      text: risk,
                      style: theme.textTheme.bodyLarge!.copyWith(
                        fontSize: 25,
                        color: riskColor,
                      ),
                    )
                  ],
                ),
              ),
              AirQuality(weather: weather),
            ],
          ),
        ),
      ),
    );
  }
}
