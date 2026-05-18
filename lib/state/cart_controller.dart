import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/album.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class CartController extends ChangeNotifier {
  static const String _cartKey = 'saved_cart_items';
  static const String _ordersKey = 'saved_orders';

  final List<CartItem> _items = [];
  final List<Order> _orders = [];

  bool _isLoading = true;

  List<CartItem> get items => List.unmodifiable(_items);
  List<Order> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;

  int get itemCount {
    int total = 0;

    for (final item in _items) {
      total += item.quantity;
    }

    return total;
  }

  double get subtotal {
    double total = 0;

    for (final item in _items) {
      total += item.totalPrice;
    }

    return total;
  }

  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    final cartJson = prefs.getString(_cartKey);
    final ordersJson = prefs.getString(_ordersKey);

    _items.clear();
    _orders.clear();

    if (cartJson != null) {
      final decodedCart = jsonDecode(cartJson) as List<dynamic>;

      for (final itemJson in decodedCart) {
        _items.add(
          CartItem.fromJson(itemJson as Map<String, dynamic>),
        );
      }
    }

    if (ordersJson != null) {
      final decodedOrders = jsonDecode(ordersJson) as List<dynamic>;

      for (final orderJson in decodedOrders) {
        _orders.add(
          Order.fromJson(orderJson as Map<String, dynamic>),
        );
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedCart = jsonEncode(
      _items.map((item) => item.toJson()).toList(),
    );

    await prefs.setString(_cartKey, encodedCart);
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();

    final encodedOrders = jsonEncode(
      _orders.map((order) => order.toJson()).toList(),
    );

    await prefs.setString(_ordersKey, encodedOrders);
  }

  Future<void> addAlbum(Album album) async {
    final index = _items.indexWhere(
          (item) => item.album.id == album.id,
    );

    if (index == -1) {
      _items.add(
        CartItem(
          album: album,
          quantity: 1,
        ),
      );
    } else {
      final currentItem = _items[index];
      _items[index] = currentItem.copyWith(
        quantity: currentItem.quantity + 1,
      );
    }

    notifyListeners();
    await _saveCart();
  }

  Future<void> decreaseAlbum(String albumId) async {
    final index = _items.indexWhere(
          (item) => item.album.id == albumId,
    );

    if (index == -1) {
      return;
    }

    final currentItem = _items[index];

    if (currentItem.quantity <= 1) {
      _items.removeAt(index);
    } else {
      _items[index] = currentItem.copyWith(
        quantity: currentItem.quantity - 1,
      );
    }

    notifyListeners();
    await _saveCart();
  }

  Future<void> removeAlbum(String albumId) async {
    _items.removeWhere(
          (item) => item.album.id == albumId,
    );

    notifyListeners();
    await _saveCart();
  }

  Future<void> clearCart() async {
    _items.clear();

    notifyListeners();
    await _saveCart();
  }

  Future<void> createOrder({
    required String customerName,
    required String email,
    required String address,
    required String deliveryType,
    required DateTime selectedDate,
    required String selectedTime,
  }) async {
    if (_items.isEmpty) {
      return;
    }

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: List.unmodifiable(_items),
      total: subtotal,
      createdAt: DateTime.now(),
      customerName: customerName,
      email: email,
      address: address,
      deliveryType: deliveryType,
      selectedDate: selectedDate,
      selectedTime: selectedTime,
    );

    _orders.insert(0, order);
    _items.clear();

    notifyListeners();

    await _saveOrders();
    await _saveCart();
  }
}