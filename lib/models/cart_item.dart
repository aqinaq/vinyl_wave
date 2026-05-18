import 'album.dart';

class CartItem {
  final Album album;
  final int quantity;

  const CartItem({
    required this.album,
    required this.quantity,
  });

  double get totalPrice => album.vinylPrice * quantity;

  CartItem copyWith({
    Album? album,
    int? quantity,
  }) {
    return CartItem(
      album: album ?? this.album,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      album: Album.fromJson(json['album'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'album': album.toJson(),
      'quantity': quantity,
    };
  }
}