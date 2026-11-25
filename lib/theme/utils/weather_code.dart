import 'package:flutter/material.dart';

// Mengubah kode cuaca dari API menjadi teks dan ikon
class WeatherCode {
  static String label(int code) {
    if (code == 0) return 'Cerah';
    if (code <= 2) return 'Cerah Berawan';
    if (code == 3) return 'Berawan';
    if (code <= 48) return 'Berkabut';
    if (code <= 57) return 'Gerimis';
    if (code <= 67) return 'Hujan';
    if (code <= 77) return 'Salju';
    if (code <= 82) return 'Hujan Lokal';
    if (code <= 86) return 'Salju Lokal';
    return 'Badai Petir';
  }

  static IconData icon(int code) {
    if (code == 0) return Icons.wb_sunny;
    if (code <= 2) return Icons.wb_cloudy_outlined;
    if (code == 3) return Icons.cloud;
    if (code <= 48) return Icons.foggy;
    if (code <= 57) return Icons.grain;
    if (code <= 67) return Icons.umbrella;
    if (code <= 77) return Icons.ac_unit;
    if (code <= 82) return Icons.umbrella;
    if (code <= 86) return Icons.ac_unit;
    return Icons.thunderstorm;
  }
}
