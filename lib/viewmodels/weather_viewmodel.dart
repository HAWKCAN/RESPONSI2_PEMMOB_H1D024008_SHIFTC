import 'package:flutter/foundation.dart';

import '../models/city_location.dart';
import '../models/weather_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();

  // Kota default jika belum pernah memilih kota
  static final CityLocation defaultCity = CityLocation(
    name: 'Jakarta',
    admin: 'DKI Jakarta',
    country: 'Indonesia',
    latitude: -6.2088,
    longitude: 106.8456,
  );

  CityLocation? _city;
  WeatherData? _weather;
  bool _isLoading = false;
  String? _error;

  CityLocation? get city => _city;
  WeatherData? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Dipanggil saat aplikasi pertama dibuka
  Future<void> init() async {
    final lastCity = await _storage.loadLastCity();
    await loadWeather(lastCity ?? defaultCity);
  }

  // Mengambil cuaca dari API untuk kota yang dipilih
  Future<void> loadWeather(CityLocation city) async {
    _city = city;
    _isLoading = true;
    _error = null;
    _weather = null;
    notifyListeners();

    try {
      _weather = await _api.getWeather(city);
      await _storage.saveLastCity(city);
    } catch (e) {
      _error = 'Gagal memuat cuaca. Periksa koneksi internet kamu.';
    }

    _isLoading = false;
    notifyListeners();
  }
}
