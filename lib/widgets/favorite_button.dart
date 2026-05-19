import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/album.dart';
import '../state/favorites_controller.dart';

class FavoriteButton extends StatefulWidget {
  final Album album;

  const FavoriteButton({
    super.key,
    required this.album,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    scaleAnimation = TweenSequence<double>(
      [
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.0,
            end: 1.35,
          ).chain(
            CurveTween(
              curve: Curves.easeOutBack,
            ),
          ),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween<double>(
            begin: 1.35,
            end: 1.0,
          ).chain(
            CurveTween(
              curve: Curves.easeIn,
            ),
          ),
          weight: 50,
        ),
      ],
    ).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> toggleFavorite() async {
    final favoritesController = context.read<FavoritesController>();
    final wasFavorite = favoritesController.isFavorite(widget.album.id);

    await controller.forward(from: 0);

    await favoritesController.toggleFavorite(widget.album);

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          wasFavorite
              ? '${widget.album.title} removed from favorites'
              : '${widget.album.title} added to favorites',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favoritesController = context.watch<FavoritesController>();
    final isFavorite = favoritesController.isFavorite(widget.album.id);

    return ScaleTransition(
      scale: scaleAnimation,
      child: IconButton(
        onPressed: toggleFavorite,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) {
            return ScaleTransition(
              scale: animation,
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            key: ValueKey<bool>(isFavorite),
            color: isFavorite ? Colors.pinkAccent : null,
          ),
        ),
      ),
    );
  }
}