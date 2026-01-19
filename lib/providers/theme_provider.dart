import 'package:flutter/material.dart';
import 'package:mood_journal/services/settings_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemeMode();
    loadBackground();
  }

  String? _currentBackground;
  final SettingsService _settingsService = SettingsService();

  String? get currentBackground => _currentBackground;

  // Tải hình nền từ máy khi khởi động app
  Future<void> loadBackground() async {
    _currentBackground = await _settingsService.getTheme();
    notifyListeners(); // Thông báo cho HomeScreen cập nhật ảnh mới
  }

  // Cập nhật hình nền mới từ ThemeScreen
  Future<void> updateBackground(String path) async {
    await _settingsService.saveTheme(path);
    _currentBackground = path;
    notifyListeners(); // Các màn hình đang dùng ảnh nền sẽ đổi ngay lập tức
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getInt('theme_mode') ?? 0;
    _themeMode = ThemeMode.values[themeModeString];
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
  }

  void toggleThemeMode() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }
}
