import '../models/explore_data.dart';
import 'album_repository.dart';
import 'album_service.dart';
import 'network_album_service.dart';

class MockMusicService {
  final AlbumRepository albumRepository = AlbumRepository(
    localService: AlbumService(),

    // Later, replace this with your real hosted JSON URL.
    // Example:
    // networkService: NetworkAlbumService(
    //   albumsUrl: 'https://your-domain.com/albums.json',
    // ),

    networkService: null,
  );

  Future<ExploreData> getExploreData() async {
    await Future.delayed(const Duration(seconds: 1));

    final albums = await albumRepository.getAlbums();

    return ExploreData(
      featuredAlbums: [
        albums[2],
        albums[4],
        albums[5],
      ],
      newVinylArrivals: [
        albums[6],
        albums[3],
        albums[1],
      ],
      fullDiscography: albums,
      genres: const [
        'K-Pop',
        'Hip-Hop',
        'Pop',
        'R&B',
        'Anthology',
      ],
    );
  }
}