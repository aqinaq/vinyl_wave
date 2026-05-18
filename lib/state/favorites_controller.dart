import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/album.dart';

class FavoritesController extends ChangeNotifier {
  static const String _favoritesKey = 'favorite_albums';

  final List<Album> _favoriteAlbums = [];
  bool _isLoading = true;

  List<Album> get favoriteAlbums => List.unmodifiable(_favoriteAlbums);
  bool get isLoading => _isLoading;

  bool isFavorite(String albumId) {
    return _favoriteAlbums.any((album) => album.id == albumId);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getString(_favoritesKey);

    _favoriteAlbums.clear();

    if (favoritesJson != null) {
      final decoded = jsonDecode(favoritesJson) as List<dynamic>;

      for (final item in decoded) {
        _favoriteAlbums.add(
          Album.fromJson(item as Map<String, dynamic>),
        );
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(Album album) async {
    if (isFavorite(album.id)) {
      _favoriteAlbums.removeWhere((item) => item.id == album.id);
    } else {
      _favoriteAlbums.add(album);
    }

    notifyListeners();
    await _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      _favoriteAlbums.map((album) => album.toJson()).toList(),
    );

    await prefs.setString(_favoritesKey, encoded);
  }
}