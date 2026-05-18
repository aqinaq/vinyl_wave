import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vinyl_wave/models/album.dart';
import 'package:vinyl_wave/models/track.dart';
import 'package:vinyl_wave/state/favorites_controller.dart';
import 'package:vinyl_wave/widgets/album_card.dart';

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
      ],
    );
  });

  testWidgets('AlbumCard displays album information', (tester) async {
    final favoritesController = FavoritesController();
    await favoritesController.loadFavorites();

    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesController>.value(
        value: favoritesController,
        child: MaterialApp(
          home: Scaffold(
            body: AlbumCard(
              album: proof,
              onTap: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Proof'), findsOneWidget);
    expect(find.text('BTS'), findsOneWidget);
    expect(find.textContaining('Anthology'), findsOneWidget);
    expect(find.textContaining('\$49.99'), findsOneWidget);
  });

  testWidgets('AlbumCard calls onTap when tapped', (tester) async {
    bool wasTapped = false;

    final favoritesController = FavoritesController();
    await favoritesController.loadFavorites();

    await tester.pumpWidget(
      ChangeNotifierProvider<FavoritesController>.value(
        value: favoritesController,
        child: MaterialApp(
          home: Scaffold(
            body: AlbumCard(
              album: wings,
              onTap: () {
                wasTapped = true;
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Wings'));
    await tester.pump();

    expect(wasTapped, true);
  });
}