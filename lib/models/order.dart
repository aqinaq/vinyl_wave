import 'cart_item.dart';

class Order {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;
  final String customerName;
  final String email;
  final String address;
  final String deliveryType;
  final DateTime selectedDate;
  final String selectedTime;

  const Order({
    required this.id,
    required this.items,
    required this.total,
    required this.createdAt,
    required this.customerName,
    required this.email,
    required this.address,
    required this.deliveryType,
    required this.selectedDate,
    required this.selectedTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      items: (json['items'] as List<dynamic>).map((itemJson) {
        return CartItem.fromJson(itemJson as Map<String, dynamic>);
      }).toList(),
      total: (json['total'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      customerName: json['customerName'] as String,
      email: json['email'] as String,
      address: json['address'] as String? ?? '',
      deliveryType: json['deliveryType'] as String? ?? 'Delivery',
      selectedDate: DateTime.parse(
        json['selectedDate'] as String? ??
            DateTime.now().toIso8601String(),
      ),
      selectedTime: json['selectedTime'] as String? ?? 'Not selected',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'createdAt': createdAt.toIso8601String(),
      'customerName': customerName,
      'email': email,
      'address': address,
      'deliveryType': deliveryType,
      'selectedDate': selectedDate.toIso8601String(),
      'selectedTime': selectedTime,
    };
  }
}