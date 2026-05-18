import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/album_inventory.dart';

class InventoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection {
    return _firestore.collection('album_inventory');
  }

  Stream<Map<String, AlbumInventory>> watchInventoryMap() {
    return _collection.snapshots().map((snapshot) {
      final inventoryMap = <String, AlbumInventory>{};

      for (final doc in snapshot.docs) {
        final inventory = AlbumInventory.fromFirestore(doc);
        inventoryMap[inventory.albumId] = inventory;
      }

      return inventoryMap;
    });
  }

  Future<void> updateInventory({
    required String albumId,
    required int stock,
    required bool isSoldOut,
    required double? salePrice,
  }) async {
    final inventory = AlbumInventory(
      albumId: albumId,
      stock: stock,
      isSoldOut: isSoldOut,
      salePrice: salePrice,
      updatedAt: DateTime.now(),
    );

    await _collection.doc(albumId).set(
      inventory.toFirestore(),
      SetOptions(merge: true),
    );
  }
}