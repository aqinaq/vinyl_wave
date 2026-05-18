import 'package:flutter/material.dart';

import '../models/album.dart';
import '../models/album_inventory.dart';
import '../services/album_repository_provider.dart';
import '../services/inventory_service.dart';

class AdminInventoryPanel extends StatelessWidget {
  const AdminInventoryPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final albumRepository = createAlbumRepository();
    final inventoryService = InventoryService();

    return FutureBuilder<List<Album>>(
      future: albumRepository.getAlbums(),
      builder: (context, albumSnapshot) {
        if (albumSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final albums = albumSnapshot.data ?? [];

        if (albums.isEmpty) {
          return const Center(
            child: Text('No albums available for admin editing.'),
          );
        }

        return StreamBuilder<Map<String, AlbumInventory>>(
          stream: inventoryService.watchInventoryMap(),
          builder: (context, inventorySnapshot) {
            final inventoryMap = inventorySnapshot.data ?? {};

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Admin Inventory',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Edit stock, sale price, and sold-out status for store albums.',
                ),

                const SizedBox(height: 16),

                for (final album in albums)
                  _AdminAlbumTile(
                    album: album,
                    inventory: inventoryMap[album.id],
                    inventoryService: inventoryService,
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _AdminAlbumTile extends StatefulWidget {
  final Album album;
  final AlbumInventory? inventory;
  final InventoryService inventoryService;

  const _AdminAlbumTile({
    required this.album,
    required this.inventory,
    required this.inventoryService,
  });

  @override
  State<_AdminAlbumTile> createState() => _AdminAlbumTileState();
}

class _AdminAlbumTileState extends State<_AdminAlbumTile> {
  late final TextEditingController stockController;
  late final TextEditingController salePriceController;

  late bool isSoldOut;

  @override
  void initState() {
    super.initState();

    stockController = TextEditingController(
      text: '${widget.inventory?.stock ?? 10}',
    );

    salePriceController = TextEditingController(
      text: widget.inventory?.salePrice?.toStringAsFixed(2) ?? '',
    );

    isSoldOut = widget.inventory?.isSoldOut ?? false;
  }

  @override
  void didUpdateWidget(covariant _AdminAlbumTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.inventory != widget.inventory) {
      stockController.text = '${widget.inventory?.stock ?? 10}';
      salePriceController.text =
          widget.inventory?.salePrice?.toStringAsFixed(2) ?? '';
      isSoldOut = widget.inventory?.isSoldOut ?? false;
    }
  }

  @override
  void dispose() {
    stockController.dispose();
    salePriceController.dispose();
    super.dispose();
  }

  Future<void> saveInventory() async {
    final stock = int.tryParse(stockController.text.trim()) ?? 0;

    final salePriceText = salePriceController.text.trim();
    final salePrice = salePriceText.isEmpty
        ? null
        : double.tryParse(salePriceText);

    await widget.inventoryService.updateInventory(
      albumId: widget.album.id,
      stock: stock,
      isSoldOut: isSoldOut,
      salePrice: salePrice,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.album.title} inventory updated.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPrice = widget.album.vinylPrice;

    return Card(
      child: ExpansionTile(
        title: Text(widget.album.title),
        subtitle: Text(
          'Base price: \$${currentPrice.toStringAsFixed(2)}',
        ),
        childrenPadding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: stockController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Stock quantity',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.inventory_2_outlined),
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: salePriceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Sale price',
              hintText: 'Leave empty for normal price',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.local_offer_outlined),
            ),
          ),

          const SizedBox(height: 12),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Sold out'),
            value: isSoldOut,
            onChanged: (value) {
              setState(() {
                isSoldOut = value;
              });
            },
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: saveInventory,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }
}