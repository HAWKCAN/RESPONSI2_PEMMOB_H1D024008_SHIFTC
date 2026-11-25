import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/city_location.dart';
import '../models/weather_model.dart';

class ApiService {
  static const String _geoUrl =
      'https://geocoding-api.open-meteo.com/v1/search';
  static const String _forecastUrl =
      'https://api.open-meteo.com/v1/forecast';

  // Mencari kota berdasarkan nama (HTTP GET)
  Future<List<CityLocation>> searchCity(String query) async {
    final uri = Uri.parse(_geoUrl).replace(queryParameters: {
      'name': query,
      'count': '10',
      'language': 'id',
      'format': 'json',
    });

    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Server gagal merespons (${response.statusCode}).');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    // Jika kota tidak ditemukan, field "results" tidak ada di JSON
    final results = body['results'] as List<dynamic>?;
    if (results == null) return [];

    return results
        .map((item) => CityLocation.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Mengambil data cuaca berdasarkan koordinat (HTTP GET)
  Future<WeatherData> getWeather(CityLocation city) async {
    final uri = Uri.parse(_forecastUrl).replace(queryParameters: {
      'latitude': city.latitude.toString(),
      'longitude': city.longitude.toString(),
      'current':
          'temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m',
      'daily':
          'weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max',
      'timezone': 'auto',
    });

    final response = await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Server gagal merespons (${response.statusCode}).');
    }

    return WeatherData.fromJson(jsonDecode(response.body));
  }
}
