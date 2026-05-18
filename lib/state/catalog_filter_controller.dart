import 'package:flutter/foundation.dart';

import '../models/album.dart';

enum CatalogSortOption {
  titleAZ,
  priceLowHigh,
  priceHighLow,
}

class CatalogFilterController extends ChangeNotifier {
  String _searchQuery = '';
  String _selectedGenre = 'All';
  CatalogSortOption _sortOption = CatalogSortOption.titleAZ;

  String get searchQuery => _searchQuery;
  String get selectedGenre => _selectedGenre;
  CatalogSortOption get sortOption => _sortOption;

  void updateSearchQuery(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void updateGenre(String value) {
    _selectedGenre = value;
    notifyListeners();
  }

  void updateSortOption(CatalogSortOption value) {
    _sortOption = value;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedGenre = 'All';
    _sortOption = CatalogSortOption.titleAZ;
    notifyListeners();
  }

  List<Album> applyFilters(List<Album> albums) {
    final query = _searchQuery.trim().toLowerCase();

    List<Album> filteredAlbums = albums.where((album) {
      final matchesSearch = query.isEmpty ||
          album.title.toLowerCase().contains(query) ||
          album.artist.toLowerCase().contains(query) ||
          album.genre.toLowerCase().contains(query) ||
          album.tracks.any(
                (track) => track.title.toLowerCase().contains(query),
          );

      final matchesGenre =
          _selectedGenre == 'All' || album.genre.contains(_selectedGenre);

      return matchesSearch && matchesGenre;
    }).toList();

    switch (_sortOption) {
      case CatalogSortOption.titleAZ:
        filteredAlbums.sort(
              (a, b) => a.title.compareTo(b.title),
        );
        break;

      case CatalogSortOption.priceLowHigh:
        filteredAlbums.sort(
              (a, b) => a.vinylPrice.compareTo(b.vinylPrice),
        );
        break;

      case CatalogSortOption.priceHighLow:
        filteredAlbums.sort(
              (a, b) => b.vinylPrice.compareTo(a.vinylPrice),
        );
        break;
    }

    return filteredAlbums;
  }
}