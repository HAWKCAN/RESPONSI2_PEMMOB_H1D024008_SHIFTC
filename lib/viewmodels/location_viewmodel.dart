import 'package:flutter/foundation.dart';

import '../models/city_location.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class LocationViewModel extends ChangeNotifier {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();

  List<CityLocation> _results = [];
  List<CityLocation> _favorites = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _error;

  List<CityLocation> get results => _results;
  List<CityLocation> get favorites => _favorites;
  bool get isLoading => _isLoading;
  bool get hasSearched => _hasSearched;
  String? get error => _error;

  Future<void> loadFavorites() async {
    _favorites = await _storage.loadFavorites();
    notifyListeners();
  }

  // Mencari kota lewat API
  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    _isLoading = true;
    _hasSearched = true;
    _error = null;
    notifyListeners();

    try {
      _results = await _api.searchCity(query.trim());
    } catch (e) {
      _results = [];
      _error = 'Gagal mencari kota. Periksa koneksi internet kamu.';
    }

    _isLoading = false;
    notifyListeners();
  }

  bool isFavorite(CityLocation city) {
    return _favorites.any((f) => f.isSameAs(city));
  }

  Future<void> toggleFavorite(CityLocation city) async {
    if (isFavorite(city)) {
      _favorites.removeWhere((f) => f.isSameAs(city));
    } else {
      _favorites.add(city);
    }
    await _storage.saveFavorites(_favorites);
    notifyListeners();
  }
}
