import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinyl_wave/screens/cart_screen.dart';
import 'package:vinyl_wave/state/cart_controller.dart';

void main() {
  testWidgets('CartScreen displays empty cart message', (tester) async {
    SharedPreferences.setMockInitialValues({});

    final cartController = CartController();
    await cartController.loadSavedData();

    await tester.pumpWidget(
      ChangeNotifierProvider<CartController>.value(
        value: cartController,
        child: const MaterialApp(
          home: Scaffold(
            body: CartScreen(),
          ),
        ),
      ),
    );

    expect(find.textContaining('Your cart is empty'), findsOneWidget);
  });
}