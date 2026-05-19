import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinyl_wave/models/album.dart';
import 'package:vinyl_wave/models/track.dart';
import 'package:vinyl_wave/state/favorites_controller.dart';
import 'package:vinyl_wave/widgets/album_card.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('AlbumCard golden test', (tester) async {
    SharedPreferences.setMockInitialValues({});

    final favoritesController = FavoritesController();
    await favoritesController.loadFavorites();

    const album = Album(
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
      ],
    );

    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(
        devices: [
          const Device(
            name: 'phone',
            size: Size(390, 180),
          ),
        ],
      )
      ..addScenario(
        name: 'album card',
        widget: ChangeNotifierProvider<FavoritesController>.value(
          value: favoritesController,
          child: MaterialApp(
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF8B5CF6),
                brightness: Brightness.dark,
              ),
            ),
            home: Scaffold(
              body: Center(
                child: AlbumCard(
                  album: album,
                  onTap: () {},
                ),
              ),
            ),
          ),
        ),
      );

    await tester.pumpDeviceBuilder(builder);

    await screenMatchesGolden(
      tester,
      'album_card',
    );
  });
}