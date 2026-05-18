import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinyl_wave/models/album.dart';
import 'package:vinyl_wave/state/cart_controller.dart';

void main() {
  late Album proof;
  late Album wings;

  setUp(() {
    SharedPreferences.setMockInitialValues({});

    proof = const Album(
      id: 'proof',
      title: 'Proof',
      artist: 'BTS',
      coverUrl: 'https://example.com/proof.jpg',
      genre: 'Anthology',
      vinylPrice: 49.99,
      tracks: [
        'Yet To Come',
        'Run BTS',
      ],
    );

    wings = const Album(
      id: 'wings',
      title: 'Wings',
      artist: 'BTS',
      coverUrl: 'https://example.com/wings.jpg',
      genre: 'K-Pop',
      vinylPrice: 36.99,
      tracks: [
        'Blood Sweat & Tears',
        'Begin',
      ],
    );
  });

  group('CartController', () {
    test('starts empty after loading with no saved data', () async {
      final cartController = CartController();

      await cartController.loadSavedData();

      expect(cartController.items, isEmpty);
      expect(cartController.orders, isEmpty);
      expect(cartController.itemCount, 0);
      expect(cartController.subtotal, 0);
      expect(cartController.isLoading, false);
    });

    test('adds album to cart', () async {
      final cartController = CartController();

      await cartController.loadSavedData();
      await cartController.addAlbum(proof);

      expect(cartController.items.length, 1);
      expect(cartController.items.first.album.title, 'Proof');
      expect(cartController.items.first.quantity, 1);
      expect(cartController.itemCount, 1);
      expect(cartController.subtotal, 49.99);
    });

    test('adding same album increases quantity', () async {
      final cartController = CartController();

      await cartController.loadSavedData();
      await cartController.addAlbum(proof);
      await cartController.addAlbum(proof);

      expect(cartController.items.length, 1);
      expect(cartController.items.first.quantity, 2);
      expect(cartController.itemCount, 2);
      expect(cartController.subtotal, 99.98);
    });

    test('adds different albums separately', () async {
      final cartController = CartController();

      await cartController.loadSavedData();
      await cartController.addAlbum(proof);
      await cartController.addAlbum(wings);

      expect(cartController.items.length, 2);
      expect(cartController.itemCount, 2);
      expect(cartController.subtotal, 86.98);
    });

    test('decreases album quantity', () async {
      final cartController = CartController();

      await cartController.loadSavedData();
      await cartController.addAlbum(proof);
      await cartController.addAlbum(proof);
      await cartController.decreaseAlbum(proof.id);

      expect(cartController.items.first.quantity, 1);
      expect(cartController.itemCount, 1);
      expect(cartController.subtotal, 49.99);
    });

    test('decreasing quantity from one removes album', () async {
      final cartController = CartController();

      await cartController.loadSavedData();
      await cartController.addAlbum(proof);
      await cartController.decreaseAlbum(proof.id);

      expect(cartController.items, isEmpty);
      expect(cartController.itemCount, 0);
      expect(cartController.subtotal, 0);
    });

    test('removes album from cart', () async {
      final cartController = CartController();

      await cartController.loadSavedData();
      await cartController.addAlbum(proof);
      await cartController.addAlbum(wings);
      await cartController.removeAlbum(proof.id);

      expect(cartController.items.length, 1);
      expect(cartController.items.first.album.id, 'wings');
      expect(cartController.itemCount, 1);
    });

    test('creates order and clears cart', () async {
      final cartController = CartController();

      await cartController.loadSavedData();
      await cartController.addAlbum(proof);
      await cartController.addAlbum(wings);

      await cartController.createOrder(
        customerName: 'Aigerim',
        email: 'test@example.com',
        address: 'Test Address',
      );

      expect(cartController.items, isEmpty);
      expect(cartController.orders.length, 1);
      expect(cartController.orders.first.customerName, 'Aigerim');
      expect(cartController.orders.first.total, 86.98);
    });
  });
}