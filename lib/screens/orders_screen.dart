import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/cart_controller.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final cartController = context.watch<CartController>();

    if (cartController.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (cartController.orders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No orders yet.\nYour BTS vinyl orders will appear here.',
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
          'Orders',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        for (final order in cartController.orders)
          Card(
            child: ExpansionTile(
              title: Text('Order #${order.id}'),
              subtitle: Text(
                '${order.deliveryType} • ${formatDate(order.selectedDate)} • ${order.selectedTime}',
              ),
              children: [
                for (final item in order.items)
                  ListTile(
                    leading: const Icon(Icons.album),
                    title: Text(item.album.title),
                    subtitle: Text('Quantity: ${item.quantity}'),
                    trailing: Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                    ),
                  ),

                const Divider(),

                ListTile(
                  leading: Icon(
                    order.deliveryType == 'Delivery'
                        ? Icons.local_shipping_outlined
                        : Icons.storefront_outlined,
                  ),
                  title: Text(order.customerName),
                  subtitle: Text(
                    '${order.email}\n${order.address}',
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.payments_outlined),
                  title: const Text('Total'),
                  trailing: Text(
                    '\$${order.total.toStringAsFixed(2)}',
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}