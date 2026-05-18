import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_wave/widgets/track_tile.dart';

void main() {
  testWidgets('TrackTile displays track name and number', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TrackTile(
            trackName: 'Run BTS',
            trackNumber: 2,
            onTap: () {},
          ),
        ),
      ),
    );

    expect(find.text('Run BTS'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.byIcon(Icons.play_circle_outline), findsOneWidget);
  });

  testWidgets('TrackTile calls onTap when tapped', (tester) async {
    bool wasTapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TrackTile(
            trackName: 'Black Swan',
            trackNumber: 1,
            onTap: () {
              wasTapped = true;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Black Swan'));
    await tester.pump();

    expect(wasTapped, true);
  });
}