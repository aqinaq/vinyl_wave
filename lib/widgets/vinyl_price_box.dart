import 'package:flutter/material.dart';

class VinylPriceBox extends StatelessWidget {
  final double price;
  final bool addedToCart;

  const VinylPriceBox({
    super.key,
    required this.price,
    required this.addedToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.album),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Vinyl Edition',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(width: 8),
          Icon(
            addedToCart ? Icons.check_circle : Icons.shopping_cart_outlined,
          ),
        ],
      ),
    );
  }
}