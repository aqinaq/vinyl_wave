import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_wave/models/album.dart';
import 'package:vinyl_wave/widgets/album_card.dart';

void main() {
  testWidgets('AlbumCard displays album information', (tester) async {
    const album = Album(
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

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AlbumCard(
            album: album,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Proof'), findsOneWidget);
    expect(find.text('BTS'), findsOneWidget);
    expect(find.textContaining('Anthology'), findsOneWidget);
  });

  testWidgets('AlbumCard calls onTap when tapped', (tester) async {
    bool wasTapped = false;

    const album = Album(
      id: 'wings',
      title: 'Wings',
      artist: 'BTS',
      coverUrl: 'https://example.com/wings.jpg',
      genre: 'K-Pop',
      vinylPrice: 36.99,
      tracks: [
        'Blood Sweat & Tears',
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AlbumCard(
            album: album,
            onTap: () {
              wasTapped = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Wings'));
    await tester.pump();

    expect(wasTapped, true);
  });
}