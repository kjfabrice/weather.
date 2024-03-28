class Suggestions {
  const Suggestions({
    required this.name,
    required this.region,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  final String name;
  final String region;
  final String country;
  final double latitude;
  final double longitude;

  static Suggestions fromJSON(json) {
    return Suggestions(
      name: json['name'],
      region: json['region'],
      country: json['country'],
      latitude: json['lat'],
      longitude: json['lon'],
    );
  }
}
