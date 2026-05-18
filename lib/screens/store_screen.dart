import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/album.dart';
import '../services/album_repository_provider.dart';
import '../state/cart_controller.dart';
import '../state/catalog_filter_controller.dart';
import '../widgets/album_cover_image.dart';
import '../widgets/catalog_filter_bar.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  int _calculateCrossAxisCount(double width) {
    if (width >= 1100) {
      return 5;
    } else if (width >= 800) {
      return 4;
    } else if (width >= 560) {
      return 3;
    } else {
      return 2;
    }
  }

  List<String> _extractGenres(List<Album> albums) {
    final genres = <String>{};

    for (final album in albums) {
      if (album.genre.contains('/')) {
        final splitGenres = album.genre.split('/');

        for (final genre in splitGenres) {
          genres.add(genre.trim());
        }
      } else {
        genres.add(album.genre.trim());
      }
    }

    return genres.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    final cartController = context.read<CartController>();
    final albumRepository = createAlbumRepository();

    return FutureBuilder<List<Album>>(
      future: albumRepository.getAlbums(),
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
              child: Text(
                'Could not load vinyl store.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          );
        }

        final albums = snapshot.data ?? [];

        if (albums.isEmpty) {
          return Center(
            child: Text(
              'No vinyl records available.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        final genres = _extractGenres(albums);
        final filterController = context.watch<CatalogFilterController>();
        final filteredAlbums = filterController.applyFilters(albums);

        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = _calculateCrossAxisCount(
              constraints.maxWidth,
            );

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),
                    child: Text(
                      'Vinyl Store',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: Text(
                      'Search, filter, and shop BTS vinyl editions.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: CatalogFilterBar(
                    genres: genres,
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: Text(
                      '${filteredAlbums.length} vinyl record(s) found',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),

                if (filteredAlbums.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Icon(Icons.search_off, size: 64),
                          const SizedBox(height: 16),
                          Text(
                            'No vinyl records match your search.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Try another keyword or reset filters.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 140),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final album = filteredAlbums[index];

                          return _StoreVinylCard(
                            album: album,
                            onTap: () {
                              context.push('/album/${album.id}');
                            },
                            onAddToCart: () {
                              cartController.addAlbum(album);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                  Text('${album.title} added to cart'),
                                ),
                              );
                            },
                          );
                        },
                        childCount: filteredAlbums.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.78,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _StoreVinylCard extends StatelessWidget {
  final Album album;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const _StoreVinylCard({
    required this.album,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: AlbumCoverImage(
                      imagePath: album.coverUrl,
                      borderRadius: 16,
                      padding: 8,
                      fit: BoxFit.contain,
                      fallbackIconSize: 42,
                      backgroundColor: const Color(0xFF201C2B),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                album.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                album.artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      '\$${album.vinylPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: onAddToCart,
                    icon: const Icon(Icons.add_shopping_cart),
                    tooltip: 'Add to cart',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}