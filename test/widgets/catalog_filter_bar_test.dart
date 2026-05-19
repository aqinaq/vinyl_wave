import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:vinyl_wave/state/catalog_filter_controller.dart';
import 'package:vinyl_wave/widgets/catalog_filter_bar.dart';

void main() {
  testWidgets('CatalogFilterBar accepts search input', (tester) async {
    final controller = CatalogFilterController();

    await tester.pumpWidget(
      ChangeNotifierProvider<CatalogFilterController>.value(
        value: controller,
        child: const MaterialApp(
          home: Scaffold(
            body: CatalogFilterBar(
              genres: [
                'K-Pop',
                'Pop',
                'Anthology',
              ],
            ),
          ),
        ),
      ),
    );

    await tester.enterText(
      find.byType(TextField),
      'proof',
    );

    await tester.pump();

    expect(controller.searchQuery, 'proof');
    expect(find.text('proof'), findsOneWidget);
  });

  testWidgets('CatalogFilterBar changes genre dropdown', (tester) async {
    final controller = CatalogFilterController();

    await tester.pumpWidget(
      ChangeNotifierProvider<CatalogFilterController>.value(
        value: controller,
        child: const MaterialApp(
          home: Scaffold(
            body: CatalogFilterBar(
              genres: [
                'K-Pop',
                'Pop',
                'Anthology',
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('All').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('K-Pop').last);
    await tester.pumpAndSettle();

    expect(controller.selectedGenre, 'K-Pop');
  });

  testWidgets('CatalogFilterBar resets filters', (tester) async {
    final controller = CatalogFilterController();

    controller.updateSearchQuery('proof');
    controller.updateGenre('K-Pop');
    controller.updateSortOption(CatalogSortOption.priceHighLow);

    await tester.pumpWidget(
      ChangeNotifierProvider<CatalogFilterController>.value(
        value: controller,
        child: const MaterialApp(
          home: Scaffold(
            body: CatalogFilterBar(
              genres: [
                'K-Pop',
                'Pop',
                'Anthology',
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Reset filters'));
    await tester.pump();

    expect(controller.searchQuery, '');
    expect(controller.selectedGenre, 'All');
    expect(controller.sortOption, CatalogSortOption.titleAZ);
  });
}