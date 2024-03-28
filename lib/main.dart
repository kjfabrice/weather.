import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:weather_app/screens/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 77, 81, 87)),
        useMaterial3: true,
        textTheme: GoogleFonts.ropaSansTextTheme().copyWith(
          bodyLarge: GoogleFonts.ropaSans(
            color: Theme.of(context).colorScheme.onInverseSurface,
          ),
        ),
      ),
      home: WeatherScreen(),
    );
  }
}
