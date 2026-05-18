import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinyl_wave/models/album.dart';
import 'package:vinyl_wave/models/track.dart';
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
      coverUrl: 'assets/images/proof.jpg',
      genre: 'Anthology',
      vinylPrice: 49.99,
      tracks: [
        Track(
          title: 'Yet To Come',
          audioPath: 'assets/audio/yet_to_come.mp3',
        ),
        Track(
          title: 'Run BTS',
          audioPath: 'assets/audio/run_bts.mp3',
        ),
      ],
    );

    wings = const Album(
      id: 'wings',
      title: 'Wings',
      artist: 'BTS',
      coverUrl: 'assets/images/wings.jpg',
      genre: 'K-Pop',
      vinylPrice: 36.99,
      tracks: [
        Track(
          title: 'Blood Sweat & Tears',
          audioPath: 'assets/audio/fake_love.mp3',
        ),
        Track(
          title: 'Begin',
          audioPath: 'assets/audio/dynamite.mp3',
        ),
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
      expect(cartController.subtotal, closeTo(49.99, 0.001));
    });

    test('adding same album increases quantity', () async {
      final cartController = CartController();

      await cartController.loadSavedData();
      await cartController.addAlbum(proof);
      await cartController.addAlbum(proof);

      expect(cartController.items.length, 1);
      expect(cartController.items.first.quantity, 2);
      expect(cartController.itemCount, 2);
      expect(cartController.subtotal, closeTo(99.98, 0.001));
    });

    test('adds different albums separately', () async {
      final cartController = CartController();

      await cartController.loadSavedData();
      await cartController.addAlbum(proof);
      await cartController.addAlbum(wings);

      expect(cartController.items.length, 2);
      expect(cartController.itemCount, 2);
      expect(cartController.subtotal, closeTo(86.98, 0.001));
    });

    test('decreases album quantity', () async {
      final cartController = CartController();

      await cartController.loadSavedData();
      await cartController.addAlbum(proof);
      await cartController.addAlbum(proof);
      await cartController.decreaseAlbum(proof.id);

      expect(cartController.items.first.quantity, 1);
      expect(cartController.itemCount, 1);
      expect(cartController.subtotal, closeTo(49.99, 0.001));
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
        deliveryType: 'Delivery',
        selectedDate: DateTime(2026, 5, 18),
        selectedTime: '14:30',
      );

      expect(cartController.items, isEmpty);
      expect(cartController.orders.length, 1);
      expect(cartController.orders.first.customerName, 'Aigerim');
      expect(cartController.orders.first.deliveryType, 'Delivery');
      expect(cartController.orders.first.selectedTime, '14:30');
      expect(cartController.orders.first.total, closeTo(86.98, 0.001));
    });
  });
}