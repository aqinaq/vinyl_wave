import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_wave/models/track.dart';
import 'package:vinyl_wave/widgets/track_tile.dart';

void main() {
  testWidgets('TrackTile displays track title and number', (tester) async {
    const track = Track(
      title: 'Run BTS',
      audioPath: 'assets/audio/run_bts.mp3',
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TrackTile(
            track: track,
            trackNumber: 2,
            onTap: null,
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

    const track = Track(
      title: 'Black Swan',
      audioPath: 'assets/audio/fake_love.mp3',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TrackTile(
            track: track,
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