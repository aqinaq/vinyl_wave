import '../models/album.dart';
import 'album_service.dart';
import 'network_album_service.dart';

class AlbumRepository {
  final AlbumService localService;
  final NetworkAlbumService? networkService;

  AlbumRepository({
    required this.localService,
    this.networkService,
  });

  Future<List<Album>> getAlbums() async {
    if (networkService == null) {
      return localService.getAlbums();
    }

    try {
      return await networkService!.getAlbums();
    } catch (error) {
      return localService.getAlbums();
    }
  }

  Future<Album?> getAlbumById(String id) async {
    final albums = await getAlbums();

    try {
      return albums.firstWhere((album) => album.id == id);
    } catch (_) {
      return null;
    }
  }
}