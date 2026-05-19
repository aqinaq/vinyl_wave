import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/animated_loading.dart';
import '../models/explore_data.dart';
import '../services/mock_music_service.dart';
import '../state/catalog_filter_controller.dart';
import '../widgets/album_card.dart';
import '../widgets/catalog_filter_bar.dart';
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
          return const AnimatedLoading(
            message: 'Loading BTS discography...',
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
        final filterController = context.watch<CatalogFilterController>();
        final filteredAlbums = filterController.applyFilters(
          exploreData.fullDiscography,
        );

        final isFiltering = filterController.searchQuery.isNotEmpty ||
            filterController.selectedGenre != 'All';

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
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Listen to tracks, discover albums, and shop vinyl editions.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            CatalogFilterBar(
              genres: exploreData.genres,
            ),

            if (!isFiltering) ...[
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
            ],

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.15),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: SectionTitle(
                key: ValueKey(
                  '${isFiltering}_${filteredAlbums.length}',
                ),
                title: isFiltering ? 'Search Results' : 'Full Discography',
                subtitle: isFiltering
                    ? '${filteredAlbums.length} album(s) found.'
                    : 'Browse all available albums.',
              ),
            ),

            if (filteredAlbums.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.search_off, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'No matching albums found.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Try another keyword, genre, or sorting option.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              for (final album in filteredAlbums)
                AlbumCard(
                  album: album,
                  onTap: () {
                    context.push('/album/${album.id}');
                  },
                ),

            const SizedBox(height: 140),
          ],
        );
      },
    );
  }
}