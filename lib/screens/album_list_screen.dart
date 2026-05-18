import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/explore_data.dart';
import '../services/mock_music_service.dart';
import '../widgets/album_card.dart';
import '../widgets/genre_card.dart';
import '../widgets/horizontal_album_list.dart';
import '../widgets/section_title.dart';

class AlbumListScreen extends StatelessWidget {
  const AlbumListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final musicService = MockMusicService();

    return FutureBuilder<ExploreData>(
      future: musicService.getExploreData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'Could not load BTS albums.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Check your connection or try again later.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Center(
            child: Text(
              'No albums found.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        final exploreData = snapshot.data!;

        return ListView(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                'BTS Discography',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                'Listen to previews and shop vinyl editions.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const SectionTitle(
              title: 'Featured Albums',
              subtitle: 'Popular records from BTS discography.',
            ),
            HorizontalAlbumList(
              albums: exploreData.featuredAlbums,
            ),
            const SectionTitle(
              title: 'New Vinyl Arrivals',
              subtitle: 'Shop selected vinyl editions.',
            ),
            HorizontalAlbumList(
              albums: exploreData.newVinylArrivals,
            ),
            const SectionTitle(
              title: 'Genres',
              subtitle: 'Explore BTS music by sound and style.',
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: exploreData.genres.length,
                itemBuilder: (context, index) {
                  return GenreCard(
                    genre: exploreData.genres[index],
                  );
                },
              ),
            ),
            const SectionTitle(
              title: 'Full Discography',
              subtitle: 'Browse all available albums.',
            ),
            for (final album in exploreData.fullDiscography)
              AlbumCard(
                album: album,
                onTap: () {
                  context.push('/album/${album.id}');
                },
              ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }
}