import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/album.dart';
import '../services/album_repository.dart';
import '../services/album_service.dart';
import '../state/player_controller.dart';
import '../widgets/album_cover_image.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final Future<List<Album>> albumsFuture;

  @override
  void initState() {
    super.initState();

    final albumRepository = AlbumRepository(
      localService: AlbumService(),
      networkService: null,
    );

    albumsFuture = albumRepository.getAlbums();
  }

  @override
  Widget build(BuildContext context) {
    final playerController = context.watch<PlayerController>();

    if (playerController.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return FutureBuilder<List<Album>>(
      future: albumsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Could not load player album.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        final albums = snapshot.data ?? [];

        if (albums.isEmpty) {
          return Center(
            child: Text(
              'No albums available for player.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        final fallbackAlbum = albums.length > 2 ? albums[2] : albums.first;
        final album = playerController.currentAlbum ?? fallbackAlbum;
        final track = playerController.currentTrack ?? album.tracks.first;

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 20),

            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: AlbumCoverImage(
                    imagePath: album.coverUrl,
                    borderRadius: 28,
                    padding: 16,
                    fit: BoxFit.contain,
                    fallbackIconSize: 90,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              track.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),

            const SizedBox(height: 8),

            Text(
              '${album.artist} • ${album.title}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 24),

            StreamBuilder<Duration?>(
              stream: playerController.durationStream,
              builder: (context, durationSnapshot) {
                final duration = durationSnapshot.data ?? Duration.zero;

                return StreamBuilder<Duration>(
                  stream: playerController.positionStream,
                  builder: (context, positionSnapshot) {
                    final position = positionSnapshot.data ?? Duration.zero;

                    final maxSeconds =
                    duration.inSeconds == 0 ? 1.0 : duration.inSeconds.toDouble();

                    final safeCurrentSeconds = position.inSeconds
                        .clamp(0, duration.inSeconds == 0 ? 1 : duration.inSeconds)
                        .toDouble();

                    return Column(
                      children: [
                        Slider(
                          value: safeCurrentSeconds,
                          min: 0,
                          max: maxSeconds,
                          onChanged: (value) {
                            playerController.seek(
                              Duration(seconds: value.round()),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(position)),
                            Text(_formatDuration(duration)),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 42,
                  onPressed: () {
                    playerController.seek(Duration.zero);
                  },
                  icon: const Icon(Icons.replay),
                ),

                const SizedBox(width: 16),

                IconButton.filled(
                  iconSize: 48,
                  onPressed: () {
                    if (playerController.currentAlbum == null ||
                        playerController.currentTrack == null) {
                      playerController.setTrack(
                        album: album,
                        track: track,
                      );
                    } else {
                      playerController.togglePlayPause();
                    }
                  },
                  icon: Icon(
                    playerController.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                ),

                const SizedBox(width: 16),

                IconButton(
                  iconSize: 42,
                  onPressed: () {
                    final nextTrack =
                    album.tracks.length > 1 ? album.tracks[1] : album.tracks.first;

                    playerController.setTrack(
                      album: album,
                      track: nextTrack,
                    );
                  },
                  icon: const Icon(Icons.skip_next),
                ),
              ],
            ),

            const SizedBox(height: 32),

            Text(
              'Volume',
              style: Theme.of(context).textTheme.titleMedium,
            ),

            Slider(
              value: playerController.volume,
              onChanged: playerController.updateVolume,
            ),

            Text(
              'Volume: ${(playerController.volume * 100).round()}%',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            SwitchListTile(
              title: const Text('Autoplay previews'),
              subtitle: const Text('Automatically continue to the next preview.'),
              value: playerController.autoplay,
              onChanged: playerController.updateAutoplay,
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}