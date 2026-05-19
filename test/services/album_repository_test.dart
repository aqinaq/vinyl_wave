import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_wave/models/album.dart';
import 'package:vinyl_wave/models/track.dart';
import 'package:vinyl_wave/services/album_repository.dart';
import 'package:vinyl_wave/services/album_service.dart';
import 'package:vinyl_wave/services/network_album_service.dart';

class FakeLocalAlbumService extends AlbumService {
  @override
  Future<List<Album>> getAlbums() async {
    return const [
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
        ],
      ),
    ];
  }
}

class FakeNetworkAlbumServiceSuccess extends NetworkAlbumService {
  FakeNetworkAlbumServiceSuccess()
      : super(
    albumsUrl: 'https://example.com/albums.json',
  );

  @override
  Future<List<Album>> getAlbums() async {
    return const [
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
    ];
  }
}

class FakeNetworkAlbumServiceFailure extends NetworkAlbumService {
  FakeNetworkAlbumServiceFailure()
      : super(
    albumsUrl: 'https://example.com/albums.json',
  );

  @override
  Future<List<Album>> getAlbums() async {
    throw Exception('Network failed');
  }
}

void main() {
  group('AlbumRepository', () {
    test('uses local service when network service is null', () async {
      final repository = AlbumRepository(
        localService: FakeLocalAlbumService(),
        networkService: null,
      );

      final albums = await repository.getAlbums();

      expect(albums.length, 1);
      expect(albums.first.id, 'proof');
      expect(albums.first.title, 'Proof');
    });

    test('uses network service when network succeeds', () async {
      final repository = AlbumRepository(
        localService: FakeLocalAlbumService(),
        networkService: FakeNetworkAlbumServiceSuccess(),
      );

      final albums = await repository.getAlbums();

      expect(albums.length, 1);
      expect(albums.first.id, 'wings');
      expect(albums.first.title, 'Wings');
    });

    test('falls back to local service when network fails', () async {
      final repository = AlbumRepository(
        localService: FakeLocalAlbumService(),
        networkService: FakeNetworkAlbumServiceFailure(),
      );

      final albums = await repository.getAlbums();

      expect(albums.length, 1);
      expect(albums.first.id, 'proof');
      expect(albums.first.title, 'Proof');
    });

    test('getAlbumById returns matching album', () async {
      final repository = AlbumRepository(
        localService: FakeLocalAlbumService(),
        networkService: null,
      );

      final album = await repository.getAlbumById('proof');

      expect(album, isNotNull);
      expect(album!.title, 'Proof');
    });

    test('getAlbumById returns null when album does not exist', () async {
      final repository = AlbumRepository(
        localService: FakeLocalAlbumService(),
        networkService: null,
      );

      final album = await repository.getAlbumById('missing');

      expect(album, isNull);
    });
  });
}