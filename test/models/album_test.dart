import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_wave/models/album.dart';

void main() {
  group('Album', () {
    test('creates Album from JSON', () {
      final json = {
        'id': 'proof',
        'title': 'Proof',
        'artist': 'BTS',
        'coverUrl': 'https://example.com/proof.jpg',
        'genre': 'Anthology',
        'vinylPrice': 49.99,
        'tracks': [
          'Yet To Come',
          'Run BTS',
          'For Youth',
        ],
      };

      final album = Album.fromJson(json);

      expect(album.id, 'proof');
      expect(album.title, 'Proof');
      expect(album.artist, 'BTS');
      expect(album.genre, 'Anthology');
      expect(album.vinylPrice, 49.99);
      expect(album.tracks.length, 3);
      expect(album.tracks.first, 'Yet To Come');
    });

    test('converts Album to JSON', () {
      const album = Album(
        id: 'wings',
        title: 'Wings',
        artist: 'BTS',
        coverUrl: 'https://example.com/wings.jpg',
        genre: 'K-Pop',
        vinylPrice: 36.99,
        tracks: [
          'Blood Sweat & Tears',
          'Begin',
        ],
      );

      final json = album.toJson();

      expect(json['id'], 'wings');
      expect(json['title'], 'Wings');
      expect(json['artist'], 'BTS');
      expect(json['genre'], 'K-Pop');
      expect(json['vinylPrice'], 36.99);
      expect(json['tracks'], [
        'Blood Sweat & Tears',
        'Begin',
      ]);
    });
  });
}