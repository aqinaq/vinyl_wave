import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_wave/models/album.dart';
import 'package:vinyl_wave/models/track.dart';
import 'package:vinyl_wave/state/catalog_filter_controller.dart';

void main() {
  late List<Album> albums;

  setUp(() {
    albums = const [
      Album(
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
          Track(
            title: 'Run BTS',
            audioPath: 'assets/audio/run_bts.mp3',
          ),
        ],
      ),
      Album(
        id: 'wings',
        title: 'Wings',
        artist: 'BTS',
        coverUrl: 'assets/images/wings.jpg',
        genre: 'K-Pop',
        vinylPrice: 36.99,
        tracks: [
          Track(
            title: 'Blood Sweat & Tears',
            audioPath: 'assets/audio/fake_love.mp3',
          ),
        ],
      ),
      Album(
        id: 'love-yourself-tear',
        title: 'Love Yourself: Tear',
        artist: 'BTS',
        coverUrl: 'assets/images/love_yourself_tear.jpeg',
        genre: 'Pop / R&B',
        vinylPrice: 39.99,
        tracks: [
          Track(
            title: 'Fake Love',
            audioPath: 'assets/audio/fake_love.mp3',
          ),
        ],
      ),
    ];
  });

  group('CatalogFilterController', () {
    test('returns all albums by default sorted by title', () {
      final controller = CatalogFilterController();

      final result = controller.applyFilters(albums);

      expect(result.length, 3);
      expect(result[0].title, 'Love Yourself: Tear');
      expect(result[1].title, 'Proof');
      expect(result[2].title, 'Wings');
    });

    test('searches by album title', () {
      final controller = CatalogFilterController();

      controller.updateSearchQuery('proof');

      final result = controller.applyFilters(albums);

      expect(result.length, 1);
      expect(result.first.id, 'proof');
    });

    test('searches by artist', () {
      final controller = CatalogFilterController();

      controller.updateSearchQuery('bts');

      final result = controller.applyFilters(albums);

      expect(result.length, 3);
    });

    test('searches by genre', () {
      final controller = CatalogFilterController();

      controller.updateSearchQuery('anthology');

      final result = controller.applyFilters(albums);

      expect(result.length, 1);
      expect(result.first.title, 'Proof');
    });

    test('searches by track title', () {
      final controller = CatalogFilterController();

      controller.updateSearchQuery('fake love');

      final result = controller.applyFilters(albums);

      expect(result.length, 1);
      expect(result.first.title, 'Love Yourself: Tear');
    });

    test('filters by genre', () {
      final controller = CatalogFilterController();

      controller.updateGenre('K-Pop');

      final result = controller.applyFilters(albums);

      expect(result.length, 1);
      expect(result.first.title, 'Wings');
    });

    test('sorts by price low to high', () {
      final controller = CatalogFilterController();

      controller.updateSortOption(CatalogSortOption.priceLowHigh);

      final result = controller.applyFilters(albums);

      expect(result.first.title, 'Wings');
      expect(result.last.title, 'Proof');
    });

    test('sorts by price high to low', () {
      final controller = CatalogFilterController();

      controller.updateSortOption(CatalogSortOption.priceHighLow);

      final result = controller.applyFilters(albums);

      expect(result.first.title, 'Proof');
      expect(result.last.title, 'Wings');
    });

    test('reset filters restores default values', () {
      final controller = CatalogFilterController();

      controller.updateSearchQuery('proof');
      controller.updateGenre('K-Pop');
      controller.updateSortOption(CatalogSortOption.priceHighLow);

      controller.resetFilters();

      expect(controller.searchQuery, '');
      expect(controller.selectedGenre, 'All');
      expect(controller.sortOption, CatalogSortOption.titleAZ);
    });
  });
}