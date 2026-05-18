import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../state/player_controller.dart';
import '../data/sample_albums.dart';
import '../models/album.dart';
import '../state/cart_controller.dart';
import '../widgets/track_tile.dart';
import '../widgets/vinyl_price_box.dart';
import '../widgets/reviews_section.dart';
import '../widgets/album_cover_image.dart';

class AlbumDetailScreen extends StatefulWidget {
  final Album album;

  const AlbumDetailScreen({
    super.key,
    required this.album,
  });

  @override
  State<AlbumDetailScreen> createState() => _AlbumDetailScreenState();
}

class _AlbumDetailScreenState extends State<AlbumDetailScreen> {
  bool isPlaying = false;
  bool addedToCart = false;

  @override
  Widget build(BuildContext context) {
    final album = widget.album;

    final relatedAlbums = sampleAlbums
        .where((otherAlbum) => otherAlbum.id != album.id)
        .take(4)
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: Text(album.title),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 320,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: AlbumCoverImage(
                      imagePath: album.coverUrl,
                      borderRadius: 24,
                      padding: 18,
                      fit: BoxFit.contain,
                      fallbackIconSize: 90,
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _AlbumInfoSection(
                album: album,
                isPlaying: isPlaying,
                addedToCart: addedToCart,
                onPlayPressed: () {
                  setState(() {
                    isPlaying = !isPlaying;
                  });
                },
                onCartPressed: () {
                  context.read<CartController>().addAlbum(album);

                  setState(() {
                    addedToCart = true;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${album.title} added to cart'),
                    ),
                  );
                },
                onSharePressed: () {
                  final link = '/album/${album.id}';

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Share link: $link'),
                    ),
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Text(
                'Tracks',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return TrackTile(
                      track: album.tracks[index],
                      trackNumber: index + 1,
                      onTap: () {
                        context.read<PlayerController>().setTrack(
                          album: album,
                          track: album.tracks[index],
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Now playing: ${album.tracks[index].title}'),
                          ),
                        );
                      },
                    );
              },
              childCount: album.tracks.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: ReviewsSection(
                albumId: album.id,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),

              child: Text(

                'Related Vinyl',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),

          SliverLayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.crossAxisExtent;
              final crossAxisCount = width >= 700 ? 4 : 2;

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final relatedAlbum = relatedAlbums[index];

                      return _RelatedVinylCard(
                        album: relatedAlbum,
                        onTap: () {
                          context.pushReplacement('/album/${relatedAlbum.id}');
                        },
                      );
                    },
                    childCount: relatedAlbums.length,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AlbumInfoSection extends StatelessWidget {
  final Album album;
  final bool isPlaying;
  final bool addedToCart;
  final VoidCallback onPlayPressed;
  final VoidCallback onCartPressed;
  final VoidCallback onSharePressed;

  const _AlbumInfoSection({
    required this.album,
    required this.isPlaying,
    required this.addedToCart,
    required this.onPlayPressed,
    required this.onCartPressed,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          album.title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 6),

        Text(
          album.artist,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 6),

        Text(
          album.genre,
          style: Theme.of(context).textTheme.bodyMedium,
        ),

        const SizedBox(height: 20),

        VinylPriceBox(
          price: album.vinylPrice,
          addedToCart: addedToCart,
        ),

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onPlayPressed,
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                label: Text(
                  isPlaying ? 'Pause Preview' : 'Play Preview',
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        OutlinedButton.icon(
          onPressed: onCartPressed,
          icon: Icon(
            addedToCart ? Icons.check : Icons.shopping_cart_outlined,
          ),
          label: Text(
            addedToCart ? 'Added to Cart' : 'Add Vinyl to Cart',
          ),
        ),

        const SizedBox(height: 12),

        OutlinedButton.icon(
          onPressed: onSharePressed,
          icon: const Icon(Icons.link),
          label: const Text('Copy Share Link'),
        ),
      ],
    );
  }
}

class _RelatedVinylCard extends StatelessWidget {
  final Album album;
  final VoidCallback onTap;

  const _RelatedVinylCard({
    required this.album,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  AlbumCoverImage(
                    imagePath: album.coverUrl,
                    width: double.infinity,
                    height: 360,
                    borderRadius: 0,
                    fallbackIconSize: 90,

              ),

              const SizedBox(height: 8),

              Text(
                album.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),

              const SizedBox(height: 4),

              Text(
                '\$${album.vinylPrice.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}