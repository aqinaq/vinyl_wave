import 'album.dart';

class ExploreData {
  final List<Album> featuredAlbums;
  final List<Album> newVinylArrivals;
  final List<Album> fullDiscography;
  final List<String> genres;

  const ExploreData({
    required this.featuredAlbums,
    required this.newVinylArrivals,
    required this.fullDiscography,
    required this.genres,
  });
}