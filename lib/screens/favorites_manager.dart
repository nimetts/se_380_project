import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();
  final List<Map<String, dynamic>> _favoriteBooks = [];
  static const String _favoritesKey = 'favoriteBooks';

  FavoritesManager._internal();

  factory FavoritesManager() {
    return _instance;
  }

  Future<void> addToFavorites(Map<String, dynamic> book) async {
    if (!_favoriteBooks.contains(book)) {
      _favoriteBooks.add(book);
      await _saveFavoritesToSharedPreferences();
    }
  }

  Future<void> removeFromFavorites(Map<String, dynamic> book) async {
    _favoriteBooks.remove(book);
    await _saveFavoritesToSharedPreferences();
  }

  bool isFavorite(Map<String, dynamic> book) {
    return _favoriteBooks.contains(book);
  }

  List<Map<String, dynamic>> getFavorites() {
    return _favoriteBooks;
  }

  Future<void> fetchFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesString = prefs.getString(_favoritesKey);

    if (favoritesString != null) {
      final List<dynamic> favoritesJson = json.decode(favoritesString);
      _favoriteBooks.clear();
      _favoriteBooks.addAll(favoritesJson.cast<Map<String, dynamic>>());
    }
  }

  Future<void> _saveFavoritesToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesString = json.encode(_favoriteBooks);
    await prefs.setString(_favoritesKey, favoritesString);
  }
}
