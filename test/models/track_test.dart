import 'package:flutter_test/flutter_test.dart';
import 'package:vinyl_wave/models/track.dart';

void main() {
  group('Track', () {
    test('creates Track from JSON', () {
      final json = {
        'title': 'Dynamite',
        'audioPath': 'assets/audio/dynamite.mp3',
      };

      final track = Track.fromJson(json);

      expect(track.title, 'Dynamite');
      expect(track.audioPath, 'assets/audio/dynamite.mp3');
    });

    test('converts Track to JSON', () {
      const track = Track(
        title: 'Fake Love',
        audioPath: 'assets/audio/fake_love.mp3',
      );

      final json = track.toJson();

      expect(json['title'], 'Fake Love');
      expect(json['audioPath'], 'assets/audio/fake_love.mp3');
    });

    test('toString returns title', () {
      const track = Track(
        title: 'Run BTS',
        audioPath: 'assets/audio/run_bts.mp3',
      );

      expect(track.toString(), 'Run BTS');
    });
  });
}