import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../state/cart_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  Set<int> selectedSegment = {0};
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  DateTime get firstDate => DateTime.now();
  DateTime get lastDate => DateTime(DateTime.now().year + 1);

  bool get isDelivery => selectedSegment.contains(0);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  String get deliveryType {
    return isDelivery ? 'Delivery' : 'Pickup';
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return 'Select date';
    }

    return '${date.day}/${date.month}/${date.year}';
  }

  String formatTime(TimeOfDay? time) {
    if (time == null) {
      return 'Select time';
    }

    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute';
  }

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDate: selectedDate ?? DateTime.now(),
    );

    if (date == null) {
      return;
    }

    setState(() {
      selectedDate = date;
    });
  }

  Future<void> pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (time == null) {
      return;
    }

    setState(() {
      selectedTime = time;
    });
  }

  Future<void> submitOrder() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date.'),
        ),
      );
      return;
    }

    if (selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time.'),
        ),
      );
      return;
    }

    await context.read<CartController>().createOrder(
      customerName: nameController.text.trim(),
      email: emailController.text.trim(),
      address: isDelivery ? addressController.text.trim() : 'Pickup',
      deliveryType: deliveryType,
      selectedDate: selectedDate!,
      selectedTime: formatTime(selectedTime),
    );

    if (!mounted) {
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Order placed'),
          content: Text(
            'Your BTS vinyl order was created successfully.\n\n'
                '$deliveryType on ${formatDate(selectedDate)} at ${formatTime(selectedTime)}.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.go('/store');
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  Widget buildOrderTypeSelector() {
    return SegmentedButton<int>(
      showSelectedIcon: false,
      segments: const [
        ButtonSegment<int>(
          value: 0,
          label: Text('Delivery'),
          icon: Icon(Icons.local_shipping_outlined),
        ),
        ButtonSegment<int>(
          value: 1,
          label: Text('Pickup'),
          icon: Icon(Icons.storefront_outlined),
        ),
      ],
      selected: selectedSegment,
      onSelectionChanged: (value) {
        setState(() {
          selectedSegment = value;
        });
      },
    );
  }

  Widget buildDateTimePicker() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: pickDate,
            icon: const Icon(Icons.calendar_month_outlined),
            label: Text(formatDate(selectedDate)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: pickTime,
            icon: const Icon(Icons.access_time),
            label: Text(formatTime(selectedTime)),
          ),
        ),
      ],
    );
  }

  Widget buildOrderSummary(CartController cartController) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            for (final item in cartController.items)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.album),
                title: Text(item.album.title),
                subtitle: Text('Quantity: ${item.quantity}'),
                trailing: Text(
                  '\$${item.totalPrice.toStringAsFixed(2)}',
                ),
              ),

            const Divider(),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Total'),
              trailing: Text(
                '\$${cartController.subtotal.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartController = context.watch<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Order Details',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          buildOrderTypeSelector(),

          const SizedBox(height: 16),

          Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Contact name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your name';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter your email';
                    }

                    if (!value.contains('@')) {
                      return 'Enter a valid email';
                    }

                    return null;
                  },
                ),

                if (isDelivery) ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Shipping address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on_outlined),
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (!isDelivery) {
                        return null;
                      }

                      if (value == null || value.trim().isEmpty) {
                        return 'Enter your address';
                      }

                      return null;
                    },
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          buildDateTimePicker(),

          const SizedBox(height: 16),

          buildOrderSummary(cartController),

          const SizedBox(height: 12),

          ElevatedButton.icon(
            onPressed: cartController.items.isEmpty ? null : submitOrder,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('Place Order'),
          ),
        ],
      ),
    );
  }
}