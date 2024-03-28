class Weather {
  final String name;
  final String country;
  final String region;
  final String conditionText;
  final String icon;
  final double lat;
  final double long;
  final double currentTemp; // temperature in Celsuis
  final double windSpeed; // wind speed in kph
  final double feelsLike;
  final double co;
  final double no2;
  final double o3;
  final double so2;
  final double pm2_5;
  final double pm10;
  final int gbDefraIndex;
  final List forecastDay;

  const Weather({
    required this.name,
    required this.country,
    required this.region,
    required this.lat,
    required this.long,
    required this.currentTemp,
    required this.feelsLike,
    required this.conditionText,
    required this.icon,
    required this.windSpeed,
    required this.co,
    required this.no2,
    required this.so2,
    required this.o3,
    required this.pm2_5,
    required this.pm10,
    required this.gbDefraIndex,
    required this.forecastDay,
  });

  static Weather fromJSON(json) {
    return Weather(
      name: json['location']['name'],
      country: json['location']['country'],
      region: json['location']['region'],
      lat: json['location']['lat'],
      long: json['location']['lon'],
      currentTemp: json['current']['temp_c'],
      feelsLike: json['current']['feelslike_c'],
      conditionText: json['current']['condition']['text'],
      co: json['current']['air_quality']['co'],
      no2: json['current']['air_quality']['no2'],
      o3: json['current']['air_quality']['o3'],
      so2: json['current']['air_quality']['so2'],
      pm2_5: json['current']['air_quality']['pm2_5'],
      pm10: json['current']['air_quality']['pm10'],
      gbDefraIndex: json['current']['air_quality']['gb-defra-index'],
      icon: json['current']['condition']['icon'],
      windSpeed: json['current']['wind_kph'],
      forecastDay: json['forecast']['forecastday'],
    );
  }
}
