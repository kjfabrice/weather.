import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:weather_app/models/weather.dart';
import 'package:weather_app/screens/add_city_screen.dart';
import 'package:weather_app/widgets/current_weather.dart';
import 'package:weather_app/widgets/forecast_weather.dart';

late List<String> kAddedCities;

class WeatherScreen extends StatefulWidget {
  WeatherScreen({super.key, this.queryParameter});

  String? queryParameter;

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  double? lat;
  double? long;
  late Future<Weather> _fetchedData;
  String city = '';
  String country = '';
  String region = '';

  @override
  void initState() {
    super.initState();
    _fetchedData = _fetchData();
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();

    lat = locationData.latitude!;
    long = locationData.longitude!;
  }

  Future<Weather> _fetchData() async {
    final SharedPreferences prefs = await _prefs;
    kAddedCities = prefs.getStringList('addedCities') ?? [];
    if (widget.queryParameter == null) {
      await _getCurrentLocation();
      widget.queryParameter = "$lat,$long";
    }

    final url = Uri.https(
      'api.weatherapi.com',
      '/v1/forecast.json',
      {
        'key': '8e85ba92d52849f4b7385155232111',
        'q': widget.queryParameter,
        'days': '3',
        'aqi': 'yes',
      },
    );

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    final weather = Weather.fromJSON(data);

    setState(() {
      city = "${weather.name},";
      country = weather.country;
      region = weather.region;
    });

    final id = '${weather.lat},${weather.long}';
    final cityWeatherData = jsonEncode(data);
    Map<String, String> location = {'id': id, 'weather': cityWeatherData};
    bool exists = false;

    for (var element in kAddedCities) {
      final addedCity = jsonDecode(element);
      final weatherData = jsonDecode(addedCity['weather']);
      if (addedCity['id'] == id ||
          weatherData['location']['name'] == data['location']['name']) {
        exists = true;
        int index = kAddedCities.indexOf(element);
        kAddedCities[index] = jsonEncode(location);
      }
    }
    if (!exists) {
      final place = jsonEncode(location);
      kAddedCities.add(place);
    }
    await prefs.setStringList('addedCities', kAddedCities);

    return weather;
  }

  void _removeCity(int cityIndex) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      kAddedCities.removeAt(cityIndex);
      prefs.setStringList('addedCities', kAddedCities);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          // systemNavigationBarColor: Colors.transparent,
        ),
        title: Text(
          "$city $region\n"
          "$country",
          softWrap: true,
          overflow: TextOverflow.fade,
          style: const TextStyle(fontSize: 17),
          textAlign: TextAlign.justify,
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.onInverseSurface,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () async {
              _fetchedData = _fetchData();
              setState(() {});
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
        leading: IconButton(
          tooltip: 'Add city',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => AddCityScreen(onRemove: _removeCity),
              ),
            );
          },
          icon: const Icon(Icons.add),
        ),
        // centerTitle: true,
      ),
      body: SingleChildScrollView(
        // wrap container with IntrinsicHeight if more widgets are added
        child: Container(
          height: MediaQuery.of(context)
              .size
              .height, // fixed height to avoid overflow
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black45,
                Color.fromARGB(255, 40, 142, 151),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Center(
              child: FutureBuilder(
                future: _fetchedData,
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      color: theme.colorScheme.onInverseSurface,
                    );
                  }

                  if (snapshot.hasError || snapshot.data == null) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        snapshot.error.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final weather = snapshot.data!;

                  return Column(
                    children: [
                      CurrentWeather(currentWeather: weather),
                      const Spacer(),
                      Forecastweather(forecastDay: weather.forecastDay),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Weather data by',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                          Image.asset(
                            'assets/weatherapi_logo.webp',
                            height: 20,
                            width: 80,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
