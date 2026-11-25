class CityLocation {
  final String name;
  final String admin;
  final String country;
  final double latitude;
  final double longitude;

  CityLocation({
    required this.name,
    required this.admin,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  // Dibuat dari JSON hasil Geocoding API
  factory CityLocation.fromJson(Map<String, dynamic> json) {
    return CityLocation(
      name: json['name'] ?? '',
      admin: json['admin1'] ?? '',
      country: json['country'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'admin1': admin,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String get displayName => admin.isEmpty ? name : '$name, $admin';

  // Dua lokasi dianggap sama jika koordinatnya sama
  bool isSameAs(CityLocation other) {
    return latitude == other.latitude && longitude == other.longitude;
  }
}
