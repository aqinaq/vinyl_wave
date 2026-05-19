import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinyl_wave/models/album.dart';
import 'package:vinyl_wave/models/track.dart';
import 'package:vinyl_wave/state/favorites_controller.dart';

void main() {
  late Album proof;

  setUp(() {
    SharedPreferences.setMockInitialValues({});

    proof = const Album(
      id: 'proof',
      title: 'Proof',
      artist: 'BTS',
      coverUrl: 'assets/images/proof.jpg',
      genre: 'Anthology',
      vinylPrice: 49.99,
      tracks: [
        Track(
          title: 'Yet To Come',
          audioPath: 'assets/audio/yet_to_come.mp3',
        ),
      ],
    );
  });

  group('FavoritesController', () {
    test('starts empty after loading with no saved favorites', () async {
      final controller = FavoritesController();

      await controller.loadFavorites();

      expect(controller.favoriteAlbums, isEmpty);
      expect(controller.isLoading, false);
    });

    test('toggleFavorite adds album when it is not favorite', () async {
      final controller = FavoritesController();

      await controller.loadFavorites();
      await controller.toggleFavorite(proof);

      expect(controller.favoriteAlbums.length, 1);
      expect(controller.favoriteAlbums.first.id, 'proof');
      expect(controller.isFavorite('proof'), true);
    });

    test('toggleFavorite removes album when it is already favorite', () async {
      final controller = FavoritesController();

      await controller.loadFavorites();
      await controller.toggleFavorite(proof);
      await controller.toggleFavorite(proof);

      expect(controller.favoriteAlbums, isEmpty);
      expect(controller.isFavorite('proof'), false);
    });

    test('favorites persist using SharedPreferences', () async {
      final controller = FavoritesController();

      await controller.loadFavorites();
      await controller.toggleFavorite(proof);

      final secondController = FavoritesController();
      await secondController.loadFavorites();

      expect(secondController.favoriteAlbums.length, 1);
      expect(secondController.favoriteAlbums.first.title, 'Proof');
    });
  });
}