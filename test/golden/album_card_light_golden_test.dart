import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF8B5CF6),
        brightness: Brightness.light,
      ),
    );
  }

  group('Golden Tests - AlbumCard Light Theme', () {
    testGoldens('support light theme placeholder states', (tester) async {
      final builder = GoldenBuilder.grid(
        columns: 2,
        widthToHeightRatio: 1.7,
      )
        ..addScenario(
          'Light - Normal',
          const _PlaceholderAlbumCard(
            isFavorite: false,
          ),
        )
        ..addScenario(
          'Light - Favorite',
          const _PlaceholderAlbumCard(
            isFavorite: true,
          ),
        )
        ..addScenario(
          'Light - Compact Normal',
          const SizedBox(
            width: 180,
            child: _PlaceholderAlbumCard(
              isFavorite: false,
            ),
          ),
        )
        ..addScenario(
          'Light - Compact Favorite',
          const SizedBox(
            width: 180,
            child: _PlaceholderAlbumCard(
              isFavorite: true,
            ),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: materialAppWrapper(
          theme: lightTheme(),
        ),
      );

      await screenMatchesGolden(
        tester,
        'album_card_light_placeholder',
      );
    });
  });
}

class _PlaceholderAlbumCard extends StatelessWidget {
  final bool isFavorite;

  const _PlaceholderAlbumCard({
    required this.isFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      height: 80,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            color: Colors.black,
          ),

          const SizedBox(width: 8),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _BlackBar(width: 86),
                SizedBox(height: 5),
                _BlackBar(width: 58),
                SizedBox(height: 5),
                _BlackBar(width: 112),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 18,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}

class _BlackBar extends StatelessWidget {
  final double width;

  const _BlackBar({
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 7,
      color: Colors.black,
    );
  }
}