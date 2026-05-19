import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/animated_loading.dart';
import '../models/album.dart';
import '../models/album_inventory.dart';
import '../services/album_repository_provider.dart';
import '../services/inventory_service.dart';
import '../state/cart_controller.dart';
import '../state/catalog_filter_controller.dart';
import '../widgets/album_cover_image.dart';
import '../widgets/catalog_filter_bar.dart';
import '../widgets/pressable_scale.dart';
import '../widgets/animated_cart_button.dart';

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
    final inventoryService = InventoryService();

    return FutureBuilder<List<Album>>(
      future: albumRepository.getAlbums(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AnimatedLoading(
            message: 'Loading vinyl store...',
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

        return StreamBuilder<Map<String, AlbumInventory>>(
          stream: inventoryService.watchInventoryMap(),
          builder: (context, inventorySnapshot) {
            final inventoryMap = inventorySnapshot.data ?? {};

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
                          style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.25),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: Text(
                            '${filteredAlbums.length} vinyl record(s) found',
                            key: ValueKey(filteredAlbums.length),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
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
                              final inventory = inventoryMap[album.id];

                              final salePrice = inventory?.salePrice;
                              final displayPrice =
                                  salePrice ?? album.vinylPrice;

                              final stock = inventory?.stock ?? 10;
                              final isSoldOut =
                                  inventory?.isSoldOut == true || stock <= 0;

                              final albumForCart = album.copyWith(
                                vinylPrice: displayPrice,
                              );

                              return _StoreVinylCard(
                                album: album,
                                displayPrice: displayPrice,
                                originalPrice: album.vinylPrice,
                                stock: stock,
                                isSoldOut: isSoldOut,
                                onTap: () {
                                  context.push('/album/${album.id}');
                                },
                                onAddToCart: () {
                                  if (isSoldOut) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${album.title} is sold out.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  cartController.addAlbum(albumForCart);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${album.title} added to cart',
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            childCount: filteredAlbums.length,
                          ),
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
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
      },
    );
  }
}

class _StoreVinylCard extends StatelessWidget {
  final Album album;
  final double displayPrice;
  final double originalPrice;
  final int stock;
  final bool isSoldOut;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const _StoreVinylCard({
    required this.album,
    required this.displayPrice,
    required this.originalPrice,
    required this.stock,
    required this.isSoldOut,
    required this.onTap,
    required this.onAddToCart,
  });

  bool get hasSalePrice => displayPrice < originalPrice;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Padding(
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
                          heroTag: 'album-cover-${album.id}',
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
                    isSoldOut ? 'Sold out' : 'Stock: $stock',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSoldOut
                          ? Theme.of(context).colorScheme.error
                          : null,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: hasSalePrice
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${originalPrice.toStringAsFixed(2)}',
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              '\$${displayPrice.toStringAsFixed(2)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                            : Text(
                          '\$${displayPrice.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      AnimatedCartButton(
                        enabled: !isSoldOut,
                        onPressed: onAddToCart,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (hasSalePrice)
              Positioned(
                top: 8,
                left: 8,
                child: Chip(
                  label: const Text('SALE'),
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                ),
              ),

            if (isSoldOut)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.48),
                  child: const Center(
                    child: Text(
                      'SOLD OUT',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}