import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/album.dart';
import '../state/favorites_controller.dart';

class FavoriteButton extends StatelessWidget {
  final Album album;

  const FavoriteButton({
    super.key,
    required this.album,
  });

  @override
  Widget build(BuildContext context) {
    final favoritesController = context.watch<FavoritesController>();
    final isFavorite = favoritesController.isFavorite(album.id);

    return IconButton(
      onPressed: () {
        favoritesController.toggleFavorite(album);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isFavorite
                  ? '${album.title} removed from favorites'
                  : '${album.title} added to favorites',
            ),
          ),
        );
      },
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
      ),
    );
  }
}