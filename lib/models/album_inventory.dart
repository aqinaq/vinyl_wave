import 'package:cloud_firestore/cloud_firestore.dart';

class AlbumInventory {
  final String albumId;
  final int stock;
  final bool isSoldOut;
  final double? salePrice;
  final DateTime updatedAt;

  const AlbumInventory({
    required this.albumId,
    required this.stock,
    required this.isSoldOut,
    required this.salePrice,
    required this.updatedAt,
  });

  factory AlbumInventory.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      ) {
    final data = snapshot.data() ?? {};

    return AlbumInventory(
      albumId: snapshot.id,
      stock: data['stock'] as int? ?? 10,
      isSoldOut: data['isSoldOut'] as bool? ?? false,
      salePrice: (data['salePrice'] as num?)?.toDouble(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'stock': stock,
      'isSoldOut': isSoldOut,
      'salePrice': salePrice,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}