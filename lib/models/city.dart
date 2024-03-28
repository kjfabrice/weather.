class City {
  const City({
    required this.name,
    required this.country,
    required this.region,
    required this.icon,
    required this.minTemp,
    required this.maxTemp,
    required this.currentTemp,
    required this.lat,
    required this.long,
  });

  final String name;
  final String country;
  final String region;
  final String icon;
  final double minTemp;
  final double maxTemp;
  final double currentTemp;
  final double lat;
  final double long;

  static dynamic toJSON(City city) {
    return {
      'name': city.name,
      'country': city.country,
      'region': city.region,
      'icon': city.icon,
      'minTemp': city.minTemp,
      'maxTemp': city.maxTemp,
      'currentTemp': city.country,
      'lat': city.lat,
      'long': city.long,
    };
  }

  static City fromJSON(json) {
    return City(
        name: json['location']['name'],
        country: json['location']['country'],
        region: json['location']['region'],
        icon: json['current']['condition']['icon'],
        minTemp: json['forecast']['forecastday'][0]['day']['mintemp_c'],
        maxTemp: json['forecast']['forecastday'][0]['day']['maxtemp_c'],
        currentTemp: json['current']['temp_c'],
        lat: json['location']['lat'],
        long: json['location']['lon']);
  }
}
