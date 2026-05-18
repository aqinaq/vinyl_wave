import 'package:flutter/material.dart';

import '../models/album.dart';
import 'album_cover_image.dart';

class CompactAlbumCard extends StatelessWidget {
  final Album album;
  final VoidCallback onTap;

  const CompactAlbumCard({
    super.key,
    required this.album,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: AlbumCoverImage(
                    imagePath: album.coverUrl,
                    borderRadius: 16,
                    padding: 10,
                    fit: BoxFit.contain,
                    fallbackIconSize: 40,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  album.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${album.vinylPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}