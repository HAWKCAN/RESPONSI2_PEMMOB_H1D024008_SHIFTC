import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/city_location.dart';

class StorageService {
  static const String _favoriteKey = 'favorites';
  static const String _lastCityKey = 'last_city';

  // Mengambil daftar lokasi favorit
  Future<List<CityLocation>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_favoriteKey) ?? [];
    return raw
        .map((item) => CityLocation.fromJson(jsonDecode(item)))
        .toList();
  }

  // Menyimpan daftar lokasi favorit
  Future<void> saveFavorites(List<CityLocation> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = favorites.map((c) => jsonEncode(c.toJson())).toList();
    await prefs.setStringList(_favoriteKey, raw);
  }

  // Mengambil kota terakhir yang dibuka
  Future<CityLocation?> loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_lastCityKey);
    if (raw == null) return null;
    return CityLocation.fromJson(jsonDecode(raw));
  }

  // Menyimpan kota terakhir yang dibuka
  Future<void> saveLastCity(CityLocation city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastCityKey, jsonEncode(city.toJson()));
  }
}
