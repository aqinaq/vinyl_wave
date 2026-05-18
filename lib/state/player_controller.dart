import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../models/album.dart';
import '../models/track.dart';
import '../services/preferences_service.dart';

class PlayerController extends ChangeNotifier {
  final PreferencesService preferencesService;
  final AudioPlayer audioPlayer = AudioPlayer();

  Album? _currentAlbum;
  Track? _currentTrack;

  bool _autoplay = false;
  double _volume = 0.7;
  bool _isLoading = true;

  PlayerController({
    required this.preferencesService,
  });

  Album? get currentAlbum => _currentAlbum;
  Track? get currentTrack => _currentTrack;
  bool get isPlaying => audioPlayer.playing;
  bool get autoplay => _autoplay;
  double get volume => _volume;
  bool get isLoading => _isLoading;

  Stream<Duration> get positionStream => audioPlayer.positionStream;
  Stream<Duration?> get durationStream => audioPlayer.durationStream;
  Stream<PlayerState> get playerStateStream => audioPlayer.playerStateStream;

  Future<void> loadPreferences() async {
    _volume = await preferencesService.getVolume();
    _autoplay = await preferencesService.getAutoplay();

    await audioPlayer.setVolume(_volume);

    _isLoading = false;
    notifyListeners();

    audioPlayer.playerStateStream.listen((_) {
      notifyListeners();
    });
  }

  Future<void> setTrack({
    required Album album,
    required Track track,
  }) async {
    _currentAlbum = album;
    _currentTrack = track;

    await audioPlayer.setAsset(track.audioPath);
    await audioPlayer.setVolume(_volume);
    await audioPlayer.play();

    notifyListeners();
  }

  Future<void> togglePlayPause() async {
    if (audioPlayer.playing) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }

    notifyListeners();
  }

  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
  }

  Future<void> updateVolume(double value) async {
    _volume = value;
    await audioPlayer.setVolume(value);
    notifyListeners();

    await preferencesService.saveVolume(value);
  }

  Future<void> updateAutoplay(bool value) async {
    _autoplay = value;
    notifyListeners();

    await preferencesService.saveAutoplay(value);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}