import '../models/explore_data.dart';
import 'album_repository_provider.dart';

class MockMusicService {
  Future<ExploreData> getExploreData() async {
    await Future.delayed(const Duration(milliseconds: 700));

    final albumRepository = createAlbumRepository();
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