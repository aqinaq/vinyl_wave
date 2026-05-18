import 'package:flutter/foundation.dart';

import '../services/preferences_service.dart';

class ThemeController extends ChangeNotifier {
  final PreferencesService preferencesService;

  bool _isDarkMode = true;
  bool _isLoading = true;

  ThemeController({
    required this.preferencesService,
  });

  bool get isDarkMode => _isDarkMode;
  bool get isLoading => _isLoading;

  Future<void> loadTheme() async {
    _isDarkMode = await preferencesService.getDarkMode();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    notifyListeners();

    await preferencesService.saveDarkMode(_isDarkMode);
  }
}