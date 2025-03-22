import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'product.dart';

class FavoriteService extends ChangeNotifier {
  List<Product> _favorites = [];
  SharedPreferences? _prefs;
  bool _initialized = false;

  FavoriteService() {
    _initialize();
  }

  List<Product> get favorites => _favorites;

  bool get isInitialized => _initialized;

  Future<void> _initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await loadFavorites();
    _initialized = true;
  }

  bool isProductInFavorites(Product product) {
    return _favorites.any((item) => item.id == product.id);
  }

  void toggleFavorite(Product product) {
    if (!_initialized) return;

    if (isProductInFavorites(product)) {
      _favorites.removeWhere((item) => item.id == product.id);
    } else {
      _favorites.add(product.copyWith());
    }
    _saveFavorites();
    notifyListeners();
  }

  void clearFavorites() {
    _favorites.clear();
    _saveFavorites();
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    if (_prefs == null) return;
    final favoritesJson =
        _favorites.map((product) => jsonEncode(product.toJson())).toList();
    await _prefs!.setStringList('favorites', favoritesJson);
  }

  Future<void> loadFavorites() async {
    if (_prefs == null) return;
    final favoritesJson = _prefs!.getStringList('favorites');
    if (favoritesJson != null) {
      _favorites = favoritesJson.map((json) {
        try {
          return Product.fromJson(jsonDecode(json));
        } catch (e) {
          print('Error decoding JSON: $e');
          return Product(
              id: 0,
              brand: 'Error',
              name: 'Error',
              price: 0.0,
              tagList: [],
              image: '',
              description: '');
        }
      }).toList();
      notifyListeners();
    }
  }
}

