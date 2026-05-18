import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_wave/widgets/vinyl_price_box.dart';

void main() {
  testWidgets('VinylPriceBox displays price and cart icon', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VinylPriceBox(
            price: 49.99,
            addedToCart: false,
          ),
        ),
      ),
    );

    expect(find.text('Vinyl Edition'), findsOneWidget);
    expect(find.text('\$49.99'), findsOneWidget);
    expect(find.byIcon(Icons.shopping_cart_outlined), findsOneWidget);
  });

  testWidgets('VinylPriceBox displays check icon when added to cart', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: VinylPriceBox(
            price: 36.99,
            addedToCart: true,
          ),
        ),
      ),
    );

    expect(find.text('\$36.99'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}