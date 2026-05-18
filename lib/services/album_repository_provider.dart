import 'album_repository.dart';
import 'album_service.dart';
import 'app_config.dart';
import 'network_album_service.dart';

AlbumRepository createAlbumRepository() {
  final remoteUrl = AppConfig.remoteAlbumsUrl;

  return AlbumRepository(
    localService: AlbumService(),
    networkService: remoteUrl == null
        ? null
        : NetworkAlbumService(
      albumsUrl: remoteUrl,
    ),
  );
}