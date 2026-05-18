import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_wave/models/album.dart';
import 'package:vinyl_wave/models/track.dart';

void main() {
  group('Album', () {
    test('creates Album from JSON with Track objects', () {
      final json = {
        'id': 'proof',
        'title': 'Proof',
        'artist': 'BTS',
        'coverUrl': 'assets/images/proof.jpg',
        'genre': 'Anthology',
        'vinylPrice': 49.99,
        'tracks': [
          {
            'title': 'Yet To Come',
            'audioPath': 'assets/audio/yet_to_come.mp3',
          },
          {
            'title': 'Run BTS',
            'audioPath': 'assets/audio/run_bts.mp3',
          },
        ],
      };

      final album = Album.fromJson(json);

      expect(album.id, 'proof');
      expect(album.title, 'Proof');
      expect(album.artist, 'BTS');
      expect(album.genre, 'Anthology');
      expect(album.vinylPrice, 49.99);
      expect(album.tracks.length, 2);
      expect(album.tracks.first.title, 'Yet To Come');
      expect(album.tracks.first.audioPath, 'assets/audio/yet_to_come.mp3');
    });

    test('converts Album to JSON with Track objects', () {
      const album = Album(
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
          Track(
            title: 'Begin',
            audioPath: 'assets/audio/dynamite.mp3',
          ),
        ],
      );

      final json = album.toJson();

      expect(json['id'], 'wings');
      expect(json['title'], 'Wings');
      expect(json['artist'], 'BTS');
      expect(json['genre'], 'K-Pop');
      expect(json['vinylPrice'], 36.99);

      final tracks = json['tracks'] as List<dynamic>;

      expect(tracks.length, 2);
      expect(tracks[0]['title'], 'Blood Sweat & Tears');
      expect(tracks[0]['audioPath'], 'assets/audio/fake_love.mp3');
      expect(tracks[1]['title'], 'Begin');
      expect(tracks[1]['audioPath'], 'assets/audio/dynamite.mp3');
    });
  });
}