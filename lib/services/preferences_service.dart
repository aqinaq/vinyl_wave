import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _darkModeKey = 'dark_mode';
  static const String _lastTabKey = 'last_tab';
  static const String _volumeKey = 'volume';
  static const String _autoplayKey = 'autoplay';
  static const String _preferredGenreKey = 'preferred_genre';

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_darkModeKey) ?? true;
  }

  Future<void> saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  Future<int> getLastTab() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastTabKey) ?? 0;
  }

  Future<void> saveLastTab(int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastTabKey, index);
  }

  Future<double> getVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_volumeKey) ?? 0.7;
  }

  Future<void> saveVolume(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_volumeKey, value);
  }

  Future<bool> getAutoplay() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_autoplayKey) ?? false;
  }

  Future<void> saveAutoplay(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoplayKey, value);
  }

  Future<String> getPreferredGenre() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_preferredGenreKey) ?? 'K-Pop';
  }

  Future<void> savePreferredGenre(String genre) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_preferredGenreKey, genre);
  }
}