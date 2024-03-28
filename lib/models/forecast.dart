class Forecast {
  final String icon;
  final String date;
  final double maxTemp;
  final double minTemp;

  const Forecast({
    required this.date,
    required this.icon,
    required this.maxTemp,
    required this.minTemp,
  });

  static Forecast fromJSON(json) {
    return Forecast(
      date: json['date'],
      icon: json['day']['condition']['icon'],
      maxTemp: json['day']['maxtemp_c'],
      minTemp: json['day']['mintemp_c'],
    );
  }
}
