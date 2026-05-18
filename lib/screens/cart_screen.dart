import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/cart_controller.dart';
import '../widgets/album_cover_image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = context.watch<CartController>();

    if (cartController.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (cartController.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Your cart is empty.\nAdd a BTS vinyl from the Store or album details.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Cart',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        for (final item in cartController.items)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  AlbumCoverImage(
                    imagePath: item.album.coverUrl,
                    width: 72,
                    height: 72,
                    borderRadius: 12,
                    fallbackIconSize: 32,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.album.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '\$${item.album.vinylPrice.toStringAsFixed(2)} each',
                        ),
                        Text(
                          'Total: \$${item.totalPrice.toStringAsFixed(2)}',
                        ),
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          cartController.addAlbum(item.album);
                        },
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        onPressed: () {
                          cartController.decreaseAlbum(item.album.id);
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                    ],
                  ),

                  IconButton(
                    onPressed: () {
                      cartController.removeAlbum(item.album.id);
                    },
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          ),

        const SizedBox(height: 20),

        Card(
          child: ListTile(
            title: const Text('Subtotal'),
            trailing: Text(
              '\$${cartController.subtotal.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),

        const SizedBox(height: 12),

        ElevatedButton.icon(
          onPressed: () {
            context.push('/checkout');
          },
          icon: const Icon(Icons.payment),
          label: const Text('Go to Checkout'),
        ),
      ],
    );
  }
}